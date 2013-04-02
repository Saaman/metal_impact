class MusicGenre::MGComponent < ActiveRecord::Base
	self.table_name = "music_genre_components"

  attr_accessible :keyword, :type

  validates_presence_of :keyword, :type
end
