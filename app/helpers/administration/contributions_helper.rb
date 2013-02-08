module Administration
	module ContributionsHelper
		def translate_object_kind(object_type)
			t("activerecord.models.#{object_type.downcase}").camelize
		end
	end
end