module Productable

  def self.included(klazz)  # klazz is that class object that included this module
    klazz.class_eval do

      #behavior
      include Contributable
      
      #associations
      has_and_belongs_to_many :artists, :before_add => :check_artists_practices, :before_remove => :check_artists_length
 

    	#attributes
      attr_accessible :release_date, :title, :cover
      
      #Cover
      mount_uploader :cover, CoverUploader

      #validations
      validates :cover, :file_size => { :in => (5.kilobytes.to_i..1.megabytes.to_i) }, :allow_blank => true
      validates :title, presence: true, length: { :maximum => 511 }
      validates :release_date, presence: true
      validates :artist_ids, :length => { :minimum => 1 }

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
      logger.info "affect artist_ids = #{artist_ids.inspect}"
    rescue Exceptions::ArtistAssociationError => exception
      self.errors["artists"] = exception.message
      return false;
    end
  end

  private
    def check_artists_practices(artist)
      #will raise exception if check does not pass
      unless artist.is_suitable_for_product_type(self.class.name.underscore)
        raise Exceptions::ArtistAssociationError.new(artist.errors[:base])
      end
    end

    def check_artists_length(artist)
      raise Exceptions::ArtistAssociationError.new(I18n.t("exceptions.artist_removal_error", artist_name: artist.name)) if self.artists.size == 1
    end 
end
