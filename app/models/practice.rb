# == Schema Information
#
# Table name: practices
#
#  id         :integer          not null, primary key
#  artist_id  :integer          not null
#  kind_cd    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Practice < ActiveRecord::Base
	#associations
	belongs_to :artist

	#attributes
	attr_accessible :kind
	as_enum :kind, band: 0, writer: 1, musician: 2

	#validations
	validates_as_enum :kind
end
