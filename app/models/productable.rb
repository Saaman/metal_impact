# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  title              :string(511)      not null
#  type               :string(7)        not null
#  release_date       :date             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#

module Productable
	
	#associations
  def self.included(klazz)  # klazz is that class object that included this module
    klazz.class_eval do

    	#attributes
      attr_accessible :release_date, :title
      has_attached_file :cover, :styles => { :medium => ["300x300>", :png], :thumb => ["50x50>", :png] }, :default_url => '/system/albums/covers/questionMarkIcon.jpg'

      #validations
      validates :title, presence: true, length: { :maximum => 511}
      validates :release_date, presence: true
      validates_attachment_content_type :cover, :content_type => /image/
      validates :artists, :length => { :minimum => 1}
      validates_associated :artists

      #callbacks
      before_save do |product|
        #"ride the lightning" turns into "Ride The Lightning"
        product.title = product.title.titleize
      end
    end
  end

  protected
    def ensure_artist_operates_as(artist, practice_kind)
      has_the_required_practice = artist.practices.exists? :kind_cd => Practice.kinds(practice_kind)
      raise Exceptions::ArtistAssociationError.new(
        I18n.t("exceptions.artist_association_error", artist_name: artist.name, practice_kind: I18n.t("activerecord.enums.practice.kinds.#{practice_kind.to_s}"))) unless has_the_required_practice
    end
end
