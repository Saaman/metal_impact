# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  type       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Artist < ActiveRecord::Base
	has_and_belongs_to_many :dvds, :class_name => "Product", :conditions => "type = 'Dvd'"
	has_and_belongs_to_many :albums, :class_name => "Product", :conditions => "type = 'Album'"
  attr_accessible :name, :kind
end
