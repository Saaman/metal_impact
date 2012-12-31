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
	#associations
  belongs_to :source_file, class_name: 'Import::SourceFile', foreign_key: 'import_source_file_id', :inverse_of => :entries
  has_many :failures, class_name: 'Import::Failure', foreign_key: 'import_entry_id'

  #persisted attributes
  attr_accessible :data, :source_id, :target_id, :target_model, :source_file, :failures

	as_enum :target_model, user: 0
	serialize :data

	#validations
	validates_as_enum :target_model, :allow_nil => true
	validates_presence_of :data, :state, :import_source_file_id
  validates_presence_of :target_model, :source_id, :if => :discovered?


	#state machine
  state_machine :initial => :new do
  	before_transition :on => :auto_discover do |entry, transition|
      entry.discover
    end

    after_failure do |entry, transition|
      Rails.logger.info "a failure occured on transition : #{transition.inspect}"
      entry.errors.full_messages.each do |msg|
        Import::Failure.new(description: msg, entry: entry).save!
      end
    end

    event :auto_discover do
    	transition :new => :discovered
    end
  end
end
