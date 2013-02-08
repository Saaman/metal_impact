# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  object          :text             not null
#  original_date   :datetime         not null
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :integer
#  updater_id      :integer
#

class Contribution < ActiveRecord::Base

	include Trackable

  self.per_page = 20

	#associations
  belongs_to :approvable, polymorphic: true

  #persisted attributes
	attr_accessible :state, :event, :object, :reason, :creator, :updater
  attr_readonly :original_date, :approvable

	as_enum :event, { create: 0, update: 1 }, prefix: true
	serialize :object

  #validations
	validates_as_enum :event
	validates_presence_of :state, :event, :approvable, :object, :original_date
	validate :object_and_approvable_must_match, :original_date_must_be_in_the_past

	#callbacks
  after_initialize do |contrib|
    #operations performed on object creation
    return unless contrib.new_record?

    check_object_has_contributions

    if object.new_record?
      self.event = :create
      object.published = false
      object.save!
    else
      self.event = :update
    end

    self.original_date = object.updated_at
    self.creator = self.updater = object.updater
    self.approvable = object
  end

  #scopes
  scope :at_state, lambda {|state_name| where(:state => state_name.to_s) }

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

  def creator_pseudo
    creator.pseudo
  end

	private

		def commit_contribution
			object.publish!
		end

		def object_and_approvable_must_match
			return if approvable.nil? || object.nil?
			errors.add(:object, :approvable_mismatch, obj_type: object.class.name.humanize, obj_id: object.id, appr_type: approvable.class.name.humanize, appr_id: approvable.id) unless (object.class == approvable.class) and (object.id == approvable.id)
		end

		def check_object_has_contributions
			raise Exceptions::ContributableError.new("Object of type '#{object.nil? ? nil : object.class.name.humanize}' dos not support contributions mechanism") unless object.kind_of? Contributable
		end

    def original_date_must_be_in_the_past
    if !original_date.blank? and original_date > DateTime.now
      errors.add(:original_date, :original_date_must_be_in_the_past)
    end
  end
end
