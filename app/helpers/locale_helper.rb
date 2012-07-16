module LocaleHelper

	def set_locale
		I18n.locale = retrieve_from_url || retrieve_from_headers || I18n.default_locale
	end

	def localized_image_tag(image_name, locale_param=I18n.locale, options={})
		localized_image_name = String.new(image_name)
		localized_image_name.insert(image_name.rindex('.'), "-#{locale_param}")
		logger.info "localized_image_name = #{path_to_image(localized_image_name)}"
		unless MetalImpact::Application.assets.find_asset(localized_image_name).nil?
			logger.info("asset trouve : #{MetalImpact::Application.assets.find_asset(localized_image_name).inspect()}")
			image_tag(localized_image_name, options)
		else
			image_tag(image_name, options)
		end
	end

	private
		def retrieve_from_headers
			request.preferred_language_from(I18n.available_locales) || request.compatible_language_from(I18n.available_locales)
		end

		def retrieve_from_url
			return nil if params[:locale].nil?
			I18n.available_locales.include?(params[:locale].to_sym) ? params[:locale]  : nil
		end

end