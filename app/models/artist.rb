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
	#no need of inverse_of here, as it preloads artist when accessing a practice. No use here
	#all practices related to an artist are saved/deleted automatically
	has_many :practices, :dependent => :destroy, autosave: true
  
  #attributes
  attr_accessible :name

  #validation
  validates :name, presence: true, length: { :maximum => 127 }
  validates :practices, :length => { :minimum => 1}
  validates_associated :practices
  
end
