# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  object          :text
#  original        :text
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :integer
#  updater_id      :integer
#

class Contribution < ActiveRecord::Base

	include Trackable

	#associations
  belongs_to :approvable, polymorphic: true

  #persisted attributes
	attr_accessible :state, :event, :object, :original, :reason, :approvable, :creator, :updater

	as_enum :event, { create: 0, update: 1 }, prefix: true
	serialize :object
  serialize :original

  #validations
	validates_as_enum :event
	validates_presence_of :state, :event, :approvable, :object
	validate :object_and_original_must_match, :nil_original_means_create_event, :object_and_approvable_must_match

	#callbacks
  before_validation do |contribution|

    #caculate event if not given
    contribution.event ||= (original.nil? && :create) || :update
  end

  #State Machine
  state_machine :state, :initial => :pending do
  	around_transition do |contribution, transition, block|
      contribution.with_lock do
        block.call
      end
    end

    #transitions
    before_transition :on => :approve, :do => :commit_contribution

    #evens
    event :approve do
      transition :pending => :approved
    end
    event :refuse do
      transition :pending => :refused
    end

  end

  def self.new_from(object, original = nil)
  	check_object_has_contributions object
  	#stampable can't work in this context, we set userstamps manually
  	return Contribution.new object: object, approvable: object, creator: object.updater, updater: object.updater if original.nil?
  	return Contribution.new object: object, approvable: original, original: original, creator: object.updater, updater: object.updater
  end

	private

		def commit_contribution
			object.publish!
		end

		def object_and_original_must_match
			return if original.nil? || object.nil?
			errors.add(:object, :entity_type_mismatch, old_type: original.class.name.humanize, new_type: object.class.name.humanize) unless object.class == original.class
			errors.add(:object, :id_mismatch, old_id: original.id, new_id: object.id) unless object.id == original.id
		end

		def nil_original_means_create_event
			errors.add(:event, :invalid_event) unless original.nil? ^ event_update?
		end

		def object_and_approvable_must_match
			return if approvable.nil? || object.nil?
			errors.add(:object, :approvable_mismatch, obj_type: object.class.name.humanize, obj_id: object.id, appr_type: approvable.class.name.humanize, appr_id: approvable.id) unless (object.class == approvable.class) and (object.id == approvable.id)
		end

		def self.check_object_has_contributions(object)
			raise Exceptions::ContributableError.new("Object of type '#{object.nil? ? nil : object.class.name.humanize}' dos not support contributions mechanism") unless object.kind_of? Contributable
		end
end
