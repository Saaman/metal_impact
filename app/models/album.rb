# == Schema Information
#
# Table name: albums
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  release_date :date
#  type         :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Album < ActiveRecord::Base
	#types list
	ALBUMS_TYPES = %w[album demo]

  attr_accessible :title, :album_type, :release_date

  #validations
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :album_type, presence: true, :inclusion => { :in => ALBUMS_TYPES}
  validates :release_date, presence: true

end
