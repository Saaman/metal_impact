module References
	COUNTRIES_CODES ||= I18nCountrySelect::Countries::COUNTRY_CODES

	def self.translate_countries(countries_codes)
		codes = (countries_codes.is_a? String) ? [countries_codes] : countries_codes
		codes.map! {|c| I18n.t(c.to_sym, :scope => :countries)}
	end
end