# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  type               :string(255)
#  release_date       :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#

class Product < ActiveRecord::Base
	#associations
	has_and_belongs_to_many :artists

	#attributes
  attr_accessible :release_date, :title, :type
  has_attached_file :cover, :styles => { :medium => ["300x300>", :png], :thumb => ["50x50>", :png] }, :default_url => '/system/albums/covers/questionMarkIcon.jpg'

  #validations
  validates :title, presence: true, uniqueness: { case_sensitive: false }
#  validates :album_type, presence: true, :inclusion => { :in => ALBUMS_TYPES}
  validates :release_date, presence: true
  validates_attachment_content_type :cover, :content_type => /image/
end
