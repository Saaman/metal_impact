# == Schema Information
#
# Table name: import_source_files
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  source_type_cd :integer
#  state          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Import::SourceFile < ActiveRecord::Base

  #associations
  has_many :entries, class_name: 'Import::Entry', foreign_key: 'import_source_file_id', :inverse_of => :source_file

	#attributes
  attr_accessible :source_type, :entry_ids, :path
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
    before_transition :loaded => :preparing_entries do |source_file, transition|
      source_file.delay(:queue => 'import_engine').prepare
    end
    before_transition :preparing_entries => :prepared, :do => :prepare_entries

    #events
    event :load_file do
      transition :new => :loaded, :if => lambda {|source_file| !source_file.source_type.nil?}
    end
    event :start_preparing do
      transition :loaded => :preparing_entries
    end
    event :prepare do
      transition :preparing_entries => :prepared
    end
  end

  def name
    File.basename(path)
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

    def prepare_entries
      self.reload
      puts "source file : #{self.inspect}"
      self.entries.each do |entry|
        entry.auto_discover
      end
    end
end
