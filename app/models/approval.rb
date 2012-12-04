# == Schema Information
#
# Table name: approvals
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state_cd        :integer          not null
#  object          :text
#  original        :text
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Approval < ActiveRecord::Base

	include Trackable

	#associations
  belongs_to :approvable, polymorphic: true

  #persisted attributes
	attr_accessible :state, :event, :object, :original, :reason, :approvable

	as_enum :state, pending: 0, approved: 1, refused: 2, fail: 3
	as_enum :event, { create: 0, update: 1 }, prefix: true
	serialize :object
  serialize :original

  #validations
	validates_as_enum :state, :event
	validates_presence_of :state, :event, :approvable, :object
	validate :object_and_original_must_match, :nil_original_means_create_event, :object_and_approvable_must_match

	#callbacks
  before_validation do |approval|
    #default state value is "pending"
    approval.state ||= :pending

    #caculate event if not given
    approval.event ||= (original.nil? && :create) || :update
  end

  def self.new_from(object, original = nil)
  	check_object_has_contributions object
  	return Approval.new object: object, approvable: object if original.nil?
  	return Approval.new object: object, approvable: original, original: original
  end

	private
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
