# == Schema Information
#
# Table name: import_source_files
#
#  id             :integer          not null, primary key
#  path           :string(255)      not null
#  source_type_cd :integer
#  state          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Import::SourceFile < ActiveRecord::Base

  STATE_VALUES = {:new => 0, :loaded => 2, :preparing_entries => 2, :prepared => 7, :importing_entries => 10, :imported => 10}
  PENDING_STATES = [:preparing_entries, :importing_entries]

  #associations
  has_many :entries, class_name: 'Import::Entry', foreign_key: 'import_source_file_id', :inverse_of => :source_file, :dependent => :destroy, :include => :failures
  has_many :failures, :through => :entries

	#attributes
  attr_accessible :source_type, :entry_ids, :path
  attr_readonly :path
  as_enum :source_type, {:metal_impact => 0}, prefix: 'is_of_type'

  #validations
  validates_as_enum :source_type, :allow_nil => true
  validates :path, :presence => true
  validates :source_type, :presence => true, :on => :update

  #state machine
  state_machine :initial => :new do

    around_transition do |source_file, transition, block|
      source_file.with_lock do
        block.call
      end
    end

    #transitions
    before_transition :on => :load_file, :do => :load_entries
    before_transition :on => :unload_file, :do => :unload_entries
    before_transition :on => :async_prepare, :do => :schedule_prepare
    before_transition :on => :async_import, :do => :schedule_import

    #events
    event :load_file do
      transition :new => :loaded, :if => lambda {|source_file| !source_file.source_type.nil?}
    end
    event :unload_file do
      transition :loaded => :new
    end
    event :async_prepare do
      transition :loaded => :preparing_entries, :unless => :has_failures?
    end
    event :async_import do
      transition :prepared => :importing_entries, :unless => :has_failures?
    end
    event :refresh_status do
      transition :preparing_entries => :loaded, :if => :has_failures?
      transition :preparing_entries => :prepared, :if => :entries_prepared?
      transition :importing_entries => :imported, :if => :all_entries_imported?
      transition :importing_entries => :prepared, :if => :import_job_finished?
      transition all => same
    end
  end

  #----------------------- Helpers ------------------------#

  def name
    File.basename(path)
  end

  def has_failures?
    !self.failures.empty?
  end

  def can_set_source_type?
    self.new? || self.loaded?
  end

  def auto_refresh
    return true if PENDING_STATES.include?(state_name)
    nil
  end

  #------------------ STATS calculation -------------------#
  def stats
    return @stats unless @stats.nil?
    @stats = self.reload.entries.group(:state).size
  end

  def entries_types_counts
    return @entries_types_counts unless @entries_types_counts.nil?
    @entries_types_counts = self.entries.where{target_model_cd != nil}.group(:target_model_cd).size
  end

  def failed_entries_count
    failures.group(:import_entry_id).pluck(:import_entry_id).count
  end

  def entries_count
    stats.values.inject(:+) || 0
  end

  def overall_progress
    return 0 if(entries_count==0)
    progress = 0
    stats.each do |key, value|
      progress += value * Import::Entry::STATE_VALUES[key.to_sym]
    end
    #this calculation works if max of Import::Entry::STATE_VALUES values equals 10
    progress*10/(entries_count)
  end

  def pending_progress
    return 0 if(entries_count==0)
    if preparing_entries?
      return stats['new'].nil? ? 0 : (stats['new'] * 20 / entries_count)
    end
    stats['flagged'].nil? ? 0 : (stats['flagged'] * 70 / entries_count)
  end

  #--------------------- Transitions ----------------------#

  def prepare
    refresh_status
    async_prepare
  end

  def import(*args)
    refresh_status
    async_import *args
  end

  def set_source_type_and_load_entries(source_type)
    update_attributes! source_type: source_type
    unload_file! if can_unload_file?
    load_file
  end


  private

    PREPARATION_BATCH_COUNT = 1000
    LOADING_BATCH_COUNT = 5000

    def load_entries

      entries_count = 0
      entries = []
      klass = "Import::#{source_type.to_s.camelize}Entry".constantize

      remote_file = get_file_from_gdrive

      sio = StringIO.new()
      remote_file.download_to_io(sio)
      YAML.load_stream(sio.string) do |record|
        logger.info "record = #{record.inspect}"
        entries << klass.new(data: HashWithIndifferentAccess.new(record), source_file: self)
        entries_count += 1

        if entries_count.modulo(LOADING_BATCH_COUNT) == 0
          klass.import entries
        end
      end
      klass.import entries
    end

    def unload_entries
      self.entries.delete_all
    end

    def schedule_prepare
      entries_count = self.entries.at_state(:new).size
      step = 0
      begin
        self.delay(:queue => 'import_engine').prepare_entries_batch
        step += 1
      end until step*PREPARATION_BATCH_COUNT > entries_count
    end

    def prepare_entries_batch
      self.reload.transaction do
        self.entries.at_state(:new).limit(PREPARATION_BATCH_COUNT).each do |entry|
          entry.auto_discover
        end
      end
    end

    def schedule_import(transition)
      entries_count = transition.args[0]
      entries_type = transition.args[1]
      ent_list = entries.at_state(:prepared)
      ent_list = ent_list.of_type(entries_type) unless entries_type.blank?
      ent_list = ent_list.limit(entries_count) unless entries_count.blank?
      ent_list.each do |entry|
        entry.self_import
      end
    end

    #------------------ Helpers -------------------#

    def entries_prepared?
      stats['prepared'] == entries_count
    end

    def all_entries_imported?
      stats['imported'] == entries_count
    end

    def import_job_finished?
      stats['flagged'].nil?
    end

    def get_file_from_gdrive
      #open a session at Google
      session = GoogleDrive.login ENV["GD_USER"], ENV["GD_PWD"]

      #Get file matching name in "Fixtures v{version}"
      collection = session.files :title => "Fixtures v#{ENV["SITE_VERSION"].chomp}", "title-exact" => true, showfolders: true
      if collection.length != 1
        flash[:error] = "collection 'Fixtures v#{ENV["SITE_VERSION"]}' was not found"
        redirect_to root_path
      end

      #return the file
      collection[0].files.each do |file|
        next unless path == file.title
        return file
      end
    end
end
