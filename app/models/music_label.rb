# == Schema Information
#
# Table name: music_labels
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  website     :string(255)
#  distributor :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class MusicLabel < ActiveRecord::Base

	#attributes
  attr_accessible :name, :website, :distributor
	
	#validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  valid_website_regex = /\Ahttp[s]*:\/\/[\w+\-.]+\.[a-z]+\z/i
	validates :website, format: { with: valid_website_regex },uniqueness: { case_sensitive: false }

	#associations
  has_many :albums
end
