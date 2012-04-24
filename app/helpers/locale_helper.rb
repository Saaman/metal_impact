module LocaleHelper

	def set_locale
		logger.debug "available_locales : #{I18n.available_locales.inspect}"
		I18n.locale = retrieve_from_user_profile || retrieve_from_headers || I18n.default_locale
	end

	private
		def retrieve_from_headers
			logger.debug "set_locale : retrieve from headers"
			logger.debug "set_locale : request.preferred_language_from(I18n.available_locales) : #{request.preferred_language_from(I18n.available_locales)}"
			logger.debug "set_locale : request.compatible_language_from(I18n.available_locales) : #{request.compatible_language_from(I18n.available_locales)}"
			request.preferred_language_from(I18n.available_locales) || request.compatible_language_from(I18n.available_locales)
		end

		def retrieve_from_user_profile
			logger.debug "set_locale : retrieve from request"
			parsed_locale = params[:locale]
			I18n.available_locales.include?(parsed_locale) ? parsed_locale  : nil
		end
end