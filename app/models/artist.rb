# == Schema Information
#
# Table name: artists
#
#  id                 :integer          not null, primary key
#  name               :string(127)      not null
#  published          :boolean          default(FALSE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  countries          :string(127)
#  cached_votes_score :integer          default(0)
#  cached_votes_total :integer          default(0)
#  cached_votes_up    :integer          default(0)
#  cached_votes_down  :integer          default(0)
#

class Artist < ActiveRecord::Base

  PRODUCT_ARTIST_PRACTICES_MAPPING ||= {:album => :band, :interview => [:band, :writer, :musician]}

  #behavior
  include Contributable
  include VotableModel

  #associations
	has_and_belongs_to_many :albums
  has_and_belongs_to_many :practices
  #default_scope includes(:practices)

  #attributes
  attr_accessible :name, :countries, :biography, :practice_ids, :practices
  serialize :countries, Array
  translates :biography

  #validation
  validates :name, presence: true, length: { :maximum => 127 }
  validates :practices, :length => { :minimum => 1}
  validates :countries, :length => { :in => 1..7 }, :array_inclusion => { :in => References::COUNTRIES_CODES }

  validate :check_artists_practices

  #callbacks
  before_validation do |artist|
    return unless artist.countries?
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

  def is_suitable_for_product_type(product_type)
    return true if product_type.nil?
    product_type = product_type.to_sym if product_type.is_a?(String)
    raise ArgumentError.new("product_type '#{product_type}' cannot be converted to a symbol") unless product_type.is_a?(Symbol)

    practice_kinds = Array(PRODUCT_ARTIST_PRACTICES_MAPPING[product_type])
    raise ArgumentError.new("product_type '#{product_type}' is not recognized as a valid product type") if practice_kinds.empty?

    unless self.practices.index { |p| practice_kinds.include?(p.kind) }
      practices_kinds_names = practice_kinds.collect { |x|  "'" + Practice.human_enum_name(:kinds, x) + "'" }
      self.errors[:practice_ids] = I18n.t("exceptions.artist_association_error", artist_name: self.name, practice_kind: practices_kinds_names.join(I18n.t("defaults.or")))
      return false
    end
    return true
  end

  private
    def check_artists_practices
      unless albums.empty?
        self.is_suitable_for_product_type(:album)
      end
    end
end
