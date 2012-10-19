module Productable

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

      validates_integrity_of :cover
      validates_processing_of :cover

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
      #will raise exception if check does not pass
      checkObj = artist.is_suitable_for_product_type(self.class.name.downcase)
      raise Exceptions::ArtistAssociationError.new(checkObj[:message]) if checkObj[:error]
    end
end
