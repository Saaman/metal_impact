class Import::Entry < ActiveRecord::Base
	#associations
  belongs_to :import_source_file

  #persisted attributes
  attr_accessible :data, :error, :source_id, :target_id, :target_model
  attr_internal

  as_enum :status, { :new => 0, ready: 1, pre_processed: 2, imported: 3, processed: 4, in_error: 5, in_treatment: 6 }, prefix: true
	as_enum :previous_status, { :new => 0, ready: 1, pre_processed: 2, imported: 3, processed: 4, in_error: 5 }, prefix: 'entry_was'
	as_enum :target_model, user: 0
	serialize :data

	#validations
	validates_as_enum :status, :previous_status, :target_model
	validates_presence_of :data, :status
	validates_presence_of :previous_status, :on => :update
	validate :status_transition_is_allowed, :on => :update

	#callbacks
  before_validation do |entry|
    #default status value is "new"
    entry.status ||= :new
  end

  private
		def status_transition_is_allowed

			#in case of first step:
			return entry_in_treatment? || entry_new? if previous_status.nil?

			#=> out_of_process statuses
			if self.status_cd > 4
				#can jump from any non-final status to in_treatment
				return false if self.entry_in_treatment? && self.entry_was_processed?

				#can jump from any non-final status to in_error
				return false if self.entry_in_treatment? && self.entry_was_in_error?
				return true;
			end

			#in normal process, you can't jump over a step
			return true if (status_cd - previous_status_cd == 1)
			return false
		end
end
