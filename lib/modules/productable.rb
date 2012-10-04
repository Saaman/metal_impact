module Productable
	
  PRODUCT_ARTIST_PRACTICES_MAPPING ||= {:album => :band, :interview => [:band, :writer, :musician]}

  def self.included(klazz)  # klazz is that class object that included this module
    klazz.class_eval do

      #behavior
      include Contributable
      
      #associations
      has_and_belongs_to_many :artists, :before_add => :check_artists_practices

    	#attributes
      attr_accessible :release_date, :title, :cover
      
      #Cover
      mount_uploader :cover, CoverUploader

      #validations
      validates :title, presence: true, length: { :maximum => 511}
      validates :release_date, presence: true
      validates :artist_ids, :length => { :minimum => 1}

      #callbacks
      before_save do |product|
        #"ride the lightning" turns into "Ride The Lightning"
        product.title = product.title.titleize
      end
    end
  end

  def try_set_artist_ids(artist_ids)
    begin
      self.artist_ids = artist_ids
    rescue Exceptions::ArtistAssociationError => exception
      self.errors["artists"] = exception.message
      return false;
    end
  end

  private
    def check_artists_practices(artist)
      practice_kinds = Array(PRODUCT_ARTIST_PRACTICES_MAPPING[self.class.name.downcase.to_sym])
      unless artist.practices.exists? :kind_cd => Practice.kinds(*practice_kinds)
        practices_kinds_names = practice_kinds.collect { |x|  "'" + Practice.human_enum_name(:kinds, x) + "'" }
        raise Exceptions::ArtistAssociationError.new(I18n.t("exceptions.artist_association_error", artist_name: artist.name, practice_kind: practices_kinds_names.join(I18n.t("defaults.or"))))
      end
    end
end
