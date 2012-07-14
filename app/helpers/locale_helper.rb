module LocaleHelper

	def set_locale
		I18n.locale = params[:locale] || retrieve_from_user_profile || retrieve_from_headers || I18n.default_locale
	end

	def localized_image_tag(image_name, options={})
		localized_image_name = String.new(image_name)
		localized_image_name.insert(image_name.rindex('.'), "-#{I18n.locale}")
		if File.exist?(image_path(localized_image_name))
			image_tag(localized_image_name, options)
		else
			image_tag(image_name, options)
		end
	end

	private
		def retrieve_from_headers
			request.preferred_language_from(I18n.available_locales) || request.compatible_language_from(I18n.available_locales)
		end

		def retrieve_from_user_profile
			parsed_locale = params[:locale]
			I18n.available_locales.include?(parsed_locale) ? parsed_locale  : nil
		end

end