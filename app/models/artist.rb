# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(127)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Artist < ActiveRecord::Base
	#associations
	has_and_belongs_to_many :dvds, :class_name => "Product", :conditions => "type = 'Dvd'"
	has_and_belongs_to_many :albums, :class_name => "Product", :conditions => "type = 'Album'"
	has_many :practices, :dependent => :destroy
  
  #attributes
  attr_accessible :name

  #validation
  validates :name, presence: true, length: { :maximum => 127 }
  
end
