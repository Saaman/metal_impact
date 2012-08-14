# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(127)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  countries  :string(127)
#

class Artist < ActiveRecord::Base
  
	#associations
	has_and_belongs_to_many :albums
	#no need of inverse_of here, as it preloads artist when accessing a practice. No use here
	#all practices related to an artist are saved/deleted automatically
	has_many :practices, :dependent => :destroy, :inverse_of => :artist

  accepts_nested_attributes_for :practices, :allow_destroy => true
  
  #attributes
  attr_accessible :name, :practices_attributes, :countries, :biography
  serialize :countries, Array
  translates :biography

  #validation
  validates :name, presence: true, length: { :maximum => 127 }
  validates :practices, :length => { :minimum => 1}
  validates_associated :practices
  validates :countries, :length => { :in => 1..7 }, :array_inclusion => { :in => References::COUNTRIES_CODES }
  
  #callbaks
  before_validation do |artist|
    #remove duplicates
    artist.countries |= artist.countries
  end

  #scopes
  scope :operates_as, lambda { |practice_kind| joins(:practices).where(:practices => {:kind_cd => Practice.kinds(practice_kind)}) }

  #methods
  def countries_labels
    References::translate_countries self.countries
  end
end
