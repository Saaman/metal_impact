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

	#associations
  belongs_to :music_label

  #persisted attributes
	attr_accessible :kind
	accepts_nested_attributes_for :music_label

	as_enum :kind, album: 0, demo: 1, mini_album: 2, live: 3

	validates_as_enum :kind
	validates :kind, presence: true
	validates_associated :music_label, :if => :new_music_label?

	def get_artists_string
		return t("special.album.various_artists") if @artists.size > 3
		@artists.collect {|a| a.name.upcase}.join("-")
	end

	private
		def new_music_label?
			music_label.nil? || music_label.new_record?
		end
end
