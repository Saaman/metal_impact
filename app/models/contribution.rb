# == Schema Information
#
# Table name: contributions
#
#  id              :integer          not null, primary key
#  approvable_type :string(255)      not null
#  approvable_id   :integer          not null
#  event_cd        :integer          not null
#  state           :string(255)      not null
#  draft_object    :text             not null
#  reason          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Contribution < ActiveRecord::Base

	include Trackable

  self.per_page = 20

	#associations
  belongs_to :approvable, polymorphic: true
  belongs_to :whodunnit, class_name: User

  #persisted attributes
	attr_accessible :reason, :state, :draft_object
  attr_readonly :event, :approvable

	as_enum :event, { create: 0, update: 1 }, prefix: true
	serialize :draft_object

  #validations
	validates_as_enum :event
	validates_presence_of :state, :event, :approvable, :draft_object, :whodunnit
	validate :draft_object_and_approvable_must_match

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
      #transition is allowed only if there is no previous pending contribution on the same entity
      transition :pending => :approved, :if => :is_the_oldest_contribution?
    end
    event :refuse do
      transition :pending => :refused
    end

  end

  def title
    case approvable_type
      when Artist.name then approvable.name
      when Album.name then approvable.title
    end
  end

  def self.for(entity, attrs, contributor, is_new_record = false)
    raise ArgumentError.new('Cannot issue a contribution on a object not saved yet') if entity.new_record?
    raise ArgumentError.new('you must provider a valid contributor') if (contributor.nil? || contributor.new_record?)
    draft = HashWithIndifferentAccess.new(attrs)
    raise ArgumentError.new('attrs must be a valid hash coming from Contributable attributes') if improper_hash(draft)

    #if the last contrib was done by the same user, use it instead of a new one
    last_contrib = last_contribution_for(entity)
    if  !last_contrib.nil? && last_contrib.whodunnit == contributor
      last_contrib.draft_object = draft
      return last_contrib
    end

    #initiate new contribution
    c = Contribution.new draft_object: draft

    #fill data
    c.approvable = entity
    c.whodunnit = contributor
    c.event = is_new_record ? :create : :update
    return c
  end

  protected
    #does not work if set as private, the draft_object_and_approvable_must_match validation can't find the method (as accessed outside the context the class itself)
    def self.improper_hash(h)
      h.nil? || h.empty? ||
      !h.include?(:id)
    end

	private

    def is_the_oldest_contribution?
      oldest_contrib = Contribution.where(approvable_type: approvable_type, approvable_id: approvable_id, state: 'pending').order('created_at ASC, id ASC').first
      return oldest_contrib.nil? || oldest_contrib == self
    end

    def self.last_contribution_for(entity)
      Contribution.where(approvable_type: entity.class.name, approvable_id: entity.id, state: 'pending').order('created_at DESC, id DESC').first
    end

		def commit_contribution
      approvable.apply_contribution draft_object if event_update?
      approvable.activity :owner => whodunnit
      approvable.publish! created_at
		end

		def draft_object_and_approvable_must_match
      if Contribution.improper_hash(draft_object)
        errors.add(:draft_object, :invalid_draft)
        return
      end
      return if approvable.nil?
			errors.add(:draft_object, :id_mismatch, draft_id: draft_object[:id], id: approvable.id) unless draft_object[:id] == approvable.id
		end

end
