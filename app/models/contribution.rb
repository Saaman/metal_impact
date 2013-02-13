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
	attr_accessible :reason, :state, :draft_object
  attr_readonly :original_date, :event, :approvable

	as_enum :event, { create: 0, update: 1 }, prefix: true
	serialize :draft_object

  #validations
	validates_as_enum :event
	validates_presence_of :state, :event, :approvable, :draft_object, :original_date
	validate :draft_object_and_approvable_must_match, :original_date_must_be_in_the_past

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
      when Artist.name then approvable.name
      when Album.name then approvable.title
    end
  end

  def self.for(entity, attrs, is_new_record)
    raise ArgumentError.new('Cannot issue a contribution on a object not saved yet') if entity.new_record?
    c = Contribution.new draft_object: HashWithIndifferentAccess.new(attrs)
    raise ArgumentError.new('attrs must be a valid hash coming from Contributable attributes') if improper_hash(c.draft_object)
    c.approvable = entity
    c.original_date = c.draft_object[:updated_at]
    c.creator_id = c.updater_id = c.draft_object[:updater_id]
    c.event = is_new_record ? :create : :update
    return c
  end

  protected
    def self.improper_hash(h)
      h.nil? || h.empty? ||
      !h.include?(:id) ||
      !h.include?(:updater_id) ||
      !h.include?(:updated_at)
    end

	private

		def commit_contribution
      approvable.apply_contribution draft_object
		end

		def draft_object_and_approvable_must_match
      if Contribution.improper_hash(draft_object)
        errors.add(:draft_object, :invalid_draft)
        return
      end
      return if approvable.nil?
			errors.add(:draft_object, :id_mismatch, draft_id: draft_object[:id], id: approvable.id) unless draft_object[:id] == approvable.id
		end

    def original_date_must_be_in_the_past
    if original_date.blank? || original_date > DateTime.now
      errors.add(:original_date, :original_date_must_be_in_the_past)
    end
  end
end
