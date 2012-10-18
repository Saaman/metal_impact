# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(127)      not null
#  published  :boolean          default(FALSE), not null
#  creator_id :integer
#  updater_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  countries  :string(127)
#

class Artist < ActiveRecord::Base
  
  #behavior
  include Contributable

	#associations
	has_and_belongs_to_many :albums
  has_and_belongs_to_many :practices
	
  #attributes
  attr_accessible :name, :countries, :biography
  serialize :countries, Array
  translates :biography

  #validation
  validates :name, presence: true, length: { :maximum => 127 }
  validates :practices, :length => { :minimum => 1}
  validates :countries, :length => { :in => 1..7 }, :array_inclusion => { :in => References::COUNTRIES_CODES }
  
  #callbacks
  before_validation do |artist|
    return if artist.countries.blank?
    #turns all to uppercase
    artist.countries.map! { |c| c.upcase }
    #remove duplicates
    artist.countries |= artist.countries
  end
  before_save do |artist|
    #"CANNIBAL CORPSE" turns into "Cannibal Corpse"
    artist.name = artist.name.titleize
  end

  #scopes
  scope :operates_as, lambda { |practice_kinds| joins(:practices).where(:practices => {:kind_cd => Practice.kinds(*practice_kinds)}) }

  #methods
  def get_countries_string
    return "" if self.countries.blank?
    References::translate_countries(self.countries).join " / "
  end

  def get_practices_string
    return "" if self.practices.blank?
    self.practices.collect {|x| "#{Practice.human_enum_name(:kinds, x.kind)}"}.join(" / ")
  end

end
