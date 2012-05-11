module LocaleHelper

	def set_locale
		I18n.locale = retrieve_from_user_profile || retrieve_from_headers || I18n.default_locale
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