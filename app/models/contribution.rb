# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  draft_object          :text             not null
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
	attr_accessible :reason, :state, :creator, :updater
  attr_readonly :original_date, :event, :draft_object, :approvable

	as_enum :event, { create: 0, update: 1 }, prefix: true
	serialize :draft_object

  #validations
	validates_as_enum :event
	validates_presence_of :state, :event, :approvable, :draft_draft_object, :original_date
	validate :draft_draft_object_and_approvable_must_match, :original_date_must_be_in_the_past

	#callbacks
  after_initialize do |contrib|
    #operations performed on draft_object creation
    return unless contrib.new_record?

    check_draft_object_has_contributions

    if draft_object.new_record?
      self.event = :create
      draft_draft_object.published = false
      draft_draft_object.save!
    else
      self.event = :update
    end


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

  def title
    case approvable_type
      when Artist.name then draft_object.name
      when Album.name then draft_object.title
    end
  end

  def self.for(entity, attrs)
    raise RuntimeError.new('Cannot issue a contribution on a object not saved yet') if self.new_record?
    c = Contribution.new draft_object: attrs, approvable: entity
    c.original_date = draft_object.updated_at
    c.creator = c.updater = draft_object.updater
  end

	private

		def commit_contribution
			draft_object.publish!
		end

		def draft_object_and_approvable_must_match
			return if approvable.nil? || draft_object.nil?
			errors.add(:draft_object, :approvable_mismatch, obj_type: draft_object.class.name.humanize, obj_id: draft_object.id, appr_type: approvable.class.name.humanize, appr_id: approvable.id) unless (draft_object.class == approvable.class) and (draft_object.id == approvable.id)
		end

		def check_draft_object_has_contributions
			raise Exceptions::ContributableError.new("draft_object of type '#{draft_object.nil? ? nil : draft_object.class.name.humanize}' dos not support contributions mechanism") unless draft_object.kind_of? Contributable
		end

    def original_date_must_be_in_the_past
    if !original_date.blank? and original_date > DateTime.now
      errors.add(:original_date, :original_date_must_be_in_the_past)
    end
  end
end
