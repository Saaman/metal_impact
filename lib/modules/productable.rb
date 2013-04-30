module Productable

  def self.included(klazz)  # klazz is that class object that included this module
    klazz.class_eval do

      #behavior
      include Contributable
      include VotableModel

      #associations
      has_and_belongs_to_many_with_deferred_save :artists
      has_many :reviews, :as => :product, :include => :reviewer


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

      validate :check_artists_practices

      #callbacks
      before_save do |product|
        #"ride the lightning" turns into "Ride The Lightning"
        product.title = product.title.titleize
      end
    end
  end

  private
    def check_artists_practices
      artists.each do |artist|
        #will raise exception if check does not pass
        unless artist.is_suitable_for_product_type(self.class.name.underscore)
          errors.add :artist_ids, :invalid
        end
      end
    end
end
