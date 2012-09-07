# == Schema Information
#
# Table name: approvals
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state_cd        :integer          not null
#  object          :text(16777216)
#  original        :text(16777216)
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Approval < ActiveRecord::Base
	#associations
  belongs_to :approvable, polymorphic: true

  #persisted attributes
	attr_accessible :state, :event, :object, :original, :reason

	as_enum :state, pending: 0, accepted: 1, refused: 2, fail: 3
	as_enum :event, create: 0, update: 1, translate: 2
	serialize :object
  serialize :original

  #validations
	validates_as_enum :state, :event
	validates_presence_of :state, :event, :approvable
	validate :object_and_original_must_match

	private
		def object_and_original_must_match
			retunr if original.nil?
			errors.add(:object, :entity_type_mismatch, old_type: original.class.humanize, new_type: object.class.humanize) unless object.class == original.class
			errors.add(:object, :id_mismatch, old_type: original.id, new_type: object.id) unless object.id == original.id
		end
end
