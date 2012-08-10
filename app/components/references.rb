module References
	COUNTRIES_CODES ||= Country.all.collect { |c| c[1] }

	def self.translate_countries(countries_codes)
		codes = (countries_codes.is_a? String) ? [countries_codes] : countries_codes
		codes.map! {|c| I18n.t(c.to_sym, :scope => :countries)}
	end
end