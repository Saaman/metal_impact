# == Schema Information
#
# Table name: music_genre_components
#
#  id         :integer          not null, primary key
#  keyword    :string(255)      not null
#  type       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MusicGenre::StyleAlteration < MusicGenre::MGComponent
end
