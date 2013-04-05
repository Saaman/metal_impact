class MusicGenre::MGComponent < ActiveRecord::Base
	self.table_name = "music_genre_components"

  attr_accessible :keyword, :type

  has_and_belongs_to_many_with_deferred_save :music_genres, join_table: 'music_genre_components_music_genres'

  validates :keyword, presence: true, uniqueness: { :scope => :type, :case_sensitive => false }
  validates :type, presence: true

  def self.from_keywords(keywords_array)
  	keywords_array.map do |keyword|
			self.where(keyword: keyword).first_or_create
		end
  end

end
