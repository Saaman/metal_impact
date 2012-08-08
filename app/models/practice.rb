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
	#no need of inverse_of here, as it preloads artist when accessing apractice. No use here
	#touch makes update the artist timestamp when associating a new practice
	belongs_to :artist, :touch => true, :inverse_of => :practices

	#attributes
	attr_accessible :kind
	as_enum :kind, band: 0, writer: 1, musician: 2

	#validations
	validates_as_enum :kind
	validates_presence_of :artist
end
