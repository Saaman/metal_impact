class ArtistAssociationValidator < ActiveModel::EachValidator
	#we expect the option[:practice_kind] to be filled
  def validate_each(record, attribute, value)
  	return if value.blank?
    
  	practice_kind = options[:practice_kind]
  	artist_ids_with_correct_practice = Artist.joins(:practices).where(:id => value, :practices => {:kind_cd => Practice.kinds(practice_kind)}).pluck('artists.id')

    Rails.logger.info "array to loop on :#{(value-artist_ids_with_correct_practice).inspect}"
    artists = record.artists
    (value - artist_ids_with_correct_practice).each do |artist_id|
      record.errors.add(attribute, :artist_wrong_kind, :artist_name => artists.at(artists.index{|a| a.id == artist_id
        } || artists.length).name, :practice_kind => I18n.t("activerecord.enums.practice.kinds.#{practice_kind.to_s}"))
    end
    return (value - artist_ids_with_correct_practice).length == 0
  end
end