# == Schema Information
#
# Table name: albums
#
#  id             :integer          not null, primary key
#  title          :string(511)      not null
#  release_date   :date             not null
#  cover          :string(255)
#  kind_cd        :integer          not null
#  published      :boolean          default(FALSE), not null
#  creator_id     :integer
#  updater_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  music_label_id :integer
#

class Album < ActiveRecord::Base

	#behavior
	include Productable

	#associations
  belongs_to :music_label

  #persisted attributes
	attr_accessible :kind
	accepts_nested_attributes_for :music_label

	delegate :name, :to => :music_label, :prefix => true

	as_enum :kind, album: 0, demo: 1, mini_album: 2, live: 3

	#validations
	validates_as_enum :kind
	validates :kind, presence: true
	validates_associated :music_label, :if => :new_music_label?

	def get_artists_string
		return t("special.various_artists") if artists.size > 3
		artists.collect {|a| a.name.upcase}.join("-")
	end

	def music_label_name
		music_label.nil? ? I18n.t("special.self_production") : music_label.name
	end

	def specific_attributes_for_contribution
		{artist_ids: .artist_ids}
	end

	private
		def new_music_label?
			music_label.nil? ? false : music_label.new_record?
		end
end
