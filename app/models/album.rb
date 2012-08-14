# == Schema Information
#
# Table name: albums
#
#  id                 :integer          not null, primary key
#  title              :string(511)      not null
#  release_date       :date             not null
#  kind_cd            :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  music_label_id     :integer
#

class Album < ActiveRecord::Base

	include Productable

	ALLOWED_PRACTICE_KIND = :band

	#associations
  belongs_to :music_label, :autosave => true, :inverse_of => :albums
  has_and_belongs_to_many :artists, :before_add => :ensure_artist_operates_as_band

	attr_accessible :kind
	attr_protected :music_label_id

	as_enum :kind, album: 0, demo: 1

	validates_as_enum :kind
	validates :kind, presence: true
	validates_associated :music_label

	validates :artists, :artist_association => {practice_kind: ALLOWED_PRACTICE_KIND}

	private
		def ensure_artist_operates_as_band(artist)
			ensure_artist_operates_as(artist, ALLOWED_PRACTICE_KIND)
		end
end
