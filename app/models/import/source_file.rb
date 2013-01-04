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

  STATE_VALUES = {:new => 0, :loaded => 2, :preparing_entries => 2, :prepared => 7}

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

  #state machine
  state_machine :initial => :new do

    around_transition do |source_file, transition, block|
      source_file.transaction do
        block.call
      end
    end

    #transitions
    before_transition :new => :loaded, :do => :load_entries
    before_transition :loaded => :new, :do => :unload_entries
    before_transition :loaded => :preparing_entries do |source_file, transition|
      source_file.delay(:queue => 'import_engine').async_prepare_entries
    end

    #events
    event :load_file do
      transition :new => :loaded, :if => lambda {|source_file| !source_file.source_type.nil?}
    end
    event :unload_file do
      transition :loaded => :new
    end
    event :start_preparing do
      transition :loaded => :preparing_entries, :unless => :has_failures?
    end
    event :refresh_status do
      transition :preparing_entries => :loaded, :if => :has_failures?
      transition :preparing_entries => :prepared, :if => :entries_prepared?
      transition all => same
    end
  end

  def name
    File.basename(path)
  end

  def has_failures?
    !self.failures.empty?
  end

  def can_set_source_type?
    self.new? || self.loaded?
  end

  def set_source_type_and_load_entries(source_type)
    self.update_attributes(source_type: source_type)
    self.unload_file! if self.can_unload_file?
    self.load_file
  end

  def stats
    return @stats unless @stats.nil?
    @stats = self.reload.entries.group(:state).size
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

  def failed_entries_count
    failures.group(:import_entry_id).pluck(:import_entry_id).count
  end

  def auto_refresh
    return true if [:preparing_entries].include?(state_name)
    nil
  end

  def prepare
    self.refresh_status
    self.start_preparing
  end

  private

    def load_entries
      entries_count = 0
      entries = []
      klass = "Import::#{source_type.to_s.camelize}Entry".constantize

      File.open(self.path, 'r') do |io|
        YAML.load_stream(io) do |record|
          entries << klass.new(data: HashWithIndifferentAccess.new(record), source_file: self)
          entries_count += 1

          if entries_count.modulo(200) == 0
            klass.import entries
          end
        end
      end
      klass.import entries
    end

    def unload_entries
      self.entries.delete_all
    end

    def async_prepare_entries
      self.reload.transaction do
        self.entries.at_state(:new).each do |entry|
          entry.auto_discover
        end
      end
    end

    def entries_prepared?
      stats['prepared'] == entries_count
    end
end
