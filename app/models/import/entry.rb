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
#  status_cd             :integer
#  previous_status_cd    :integer
#  error                 :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Import::Entry < ActiveRecord::Base
	#associations
  belongs_to :import_source_file

  #persisted attributes
  attr_accessible :data, :error, :source_id, :target_id, :target_model

  #as_enum :status, { :new => 0, ready: 1, pre_processed: 2, imported: 3, processed: 4, in_error: 5, in_treatment: 6, waiting: 7 }, prefix: 'entry'
	#as_enum :previous_status, { :new => 0, ready: 1, pre_processed: 2, imported: 3, processed: 4, in_error: 5 }, prefix: 'entry_was'
	as_enum :target_model, user: 0
	serialize :data

	#validations
	#validates_as_enum :status
	#validates_as_enum :previous_status, :target_model, :allow_nil => true
	validates_as_enum :target_model, :allow_nil => true
	validates_presence_of :data#, :status
	#validates_presence_of :previous_status, :on => :update
	#validate :status_transition_is_allowed, :on => :update

	#callbacks
  before_validation do |entry|
    #default status value is "new"
    self[:status] ||= :new
  end


  state_machine :initial => :new do
  	before_transition :new => :discovered, :do => :discover
    event :start do
    	transition :new => :discovered
    end
  end

  private
  	def discover
  		puts "I'm discovering!"
  	end

  # private

  # 	#private setter
	 #  def previous_status=(val)
	 #    write_attribute :previous_status, val
	 #  end

		# def status_transition_is_allowed
		# 	errors.add(:status, :forbidden_change, status: status, previous_status: previous_status) unless transition_allowed?
		# end

		# def transition_allowed?
		# 	logger.info "validating status change"
		# 	logger.info "entry_new? = #{entry_new?}"
		# 	logger.info "previous_status = #{previous_status}"
		# 	#in case of first step:
		# 	return entry_in_treatment? || entry_new? if previous_status.nil?

		# 	#=> out_of_process statuses
		# 	if status_cd > 4
		# 		#can jump from any non-final status to in_treatment
		# 		return false if entry_in_treatment? && entry_was_processed?

		# 		#can jump from any non-final status to in_error
		# 		return false if entry_in_treatment? && entry_was_in_error?
		# 		return true
		# 	end
		# 	logger.info "last case : status_cd - previous_status_cd = #{status_cd - previous_status_cd}"
		# 	logger.info "((status_cd - previous_status_cd) == 1) = #{((status_cd - previous_status_cd) == 1)}"
		# 	#in normal process, you can't jump over a step
		# 	return true if ((status_cd - previous_status_cd) == 1)
		# 	return false
		# end
end
