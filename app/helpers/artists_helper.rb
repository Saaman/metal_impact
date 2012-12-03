module ArtistsHelper
	def contribute_with_artist(artist, product_type_targeted)
		result = @artist.is_suitable_for_product_type(@product_type_targeted) && contribute_with(@artist)
		logger.info "errors : #{@artist.errors.full_messages}" if result
		result
	end
end