# == Schema Information
#
# Table name: albums
#
#  id                 :integer         not null, primary key
#  title              :string(255)     not null
#  release_date       :date            not null
#  album_type         :string(255)     not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  music_label_id     :integer
#

class Album < ActiveRecord::Base
	#types list
	ALBUMS_TYPES = %w[album demo]

	#attributes
  attr_accessible :title, :album_type, :release_date, :cover
  has_attached_file :cover, :styles => { :medium => ["300x300>", :png], :thumb => ["50x50>", :png] }, :default_url => '/system/albums/covers/questionMarkIcon.jpg'

  #validations
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :album_type, presence: true, :inclusion => { :in => ALBUMS_TYPES}
  validates :release_date, presence: true
  validates_attachment_content_type :cover, :content_type => /image/

  #associations
  belongs_to :music_label, :autosave => true
end
