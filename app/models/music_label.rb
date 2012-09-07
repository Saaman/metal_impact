# == Schema Information
#
# Table name: music_labels
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  website     :string(255)
#  distributor :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MusicLabel < ActiveRecord::Base

	#associations
  has_many :albums

	#attributes
  attr_accessible :name, :website, :distributor
	
	VALID_WEBSITE_PATTERN = '^http[s]*:\/\/[\w+\-.]+\.[a-z]+[\w+\-\/.]+$'

	#validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :website, format: { with: /#{VALID_WEBSITE_PATTERN}/i }, uniqueness: { case_sensitive: false }, :allow_blank => true

	before_save do |music_label|
    music_label.name = music_label.name.titleize
  end
end
