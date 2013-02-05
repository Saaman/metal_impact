class SortPresenter
	attr_accessor :sort_by

	def initialize(values_list, sort_kind = nil)
		raise ArgumentError.new("'values_list' must be an array") unless values_list.is_a? Array
		@sort_options = values_list.map do |opt|
			val = clean_option(opt)
			raise ArgumentError.new("'values_list' must be an array of symbols or strings") unless val
			val
		end

		@sort_by = (clean_option(sort_kind) || @sort_options.first)
		raise ArgumentError.new("'sort_kind' must be a valid option") unless assert_option(@sort_by)
	end

	private
		def assert_option(sort_by)
			@sort_options.include? sort_by
		end

		def clean_option(option)
			if option.is_a? String
				option.downcase.to_sym
			elsif option.is_a? Symbol
				option
			else
				nil
			end
		end
end