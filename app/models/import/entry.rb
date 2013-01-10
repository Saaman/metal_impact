# == Schema Information
#
# Table name: import_entries
#
#  id                    :integer          not null, primary key
#  target_model_cd       :integer
#  source_id             :integer
#  target_id             :integer
#  import_source_file_id :integer
#  data                  :text             not null
#  state                 :string(255)      default("new"), not null
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Import::Entry < ActiveRecord::Base

  STATE_VALUES = {:new => 1, :prepared => 3, :flagged => 0, :imported => 10}

	#associations
  belongs_to :source_file, class_name: 'Import::SourceFile', foreign_key: 'import_source_file_id', :inverse_of => :entries
  has_many :failures, class_name: 'Import::Failure', foreign_key: 'import_entry_id'

  #persisted attributes
  attr_accessible :data, :source_id, :target_id, :target_model, :source_file, :failures

	as_enum :target_model, user: 0, artist: 1
	serialize :data

	#validations
	validates_as_enum :target_model, :allow_nil => true
	validates_presence_of :data, :state, :import_source_file_id
  validates_presence_of :target_model, :source_id, :if => :prepared?


	#state machine
  state_machine :initial => :new do
  	before_transition :on => :auto_discover, :do => :discover
    before_transition :on => :import, :do => :bg_import

    around_transition do |entry, transition, block|
      entry.transaction do
        block.call
      end
    end

    after_failure do |entry, transition|
      Rails.logger.info "a failure occured on transition : #{transition.inspect}"
      entry.errors.full_messages.each do |msg|
        Import::Failure.new(description: msg, entry: entry).save!
      end
    end

    event :auto_discover do
    	transition :new => :prepared
    end
    event :import do
      transition :flagged => :imported
    end
    event :flag_for_import do
      transition :prepared => :flagged
    end
  end

  #scopes
  scope :at_state, lambda {|state_name| where(:state => state_name.to_s) }
  scope :of_type, lambda {|target_model| where(:target_model_cd => self.target_models[target_model]) }

  def async_import
    self.flag_for_import
    self.delay(:queue => 'import_engine').import
  end

  private
    def bg_import
      puts "importing entry #{id}"
    end
end
