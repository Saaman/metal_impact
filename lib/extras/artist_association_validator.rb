class ArtistAssociationValidator < ActiveModel::EachValidator
	#we expect the option[:practice_kind] to be filled
  def validate_each(record, attribute, value)
  	return if value.blank?
  	practice_kind = options[:practice_kind]
  	wrongly_associated_artists = Artist.includes(:practices).where(:id => record.id, :practices => {:kind_cd => Practice.kinds(practice_kind)})
    
    wrongly_associated_artists.each do |artist|
      record.errors.add(attribute, :artist_wrong_kind, :artist_name => artist.name, :practice_kind => I18n.t("activerecord.enums.practice.kinds.#{practice_kind.to_s}"))
    end
    return wrongly_associated_artists.count == 0
  end
end