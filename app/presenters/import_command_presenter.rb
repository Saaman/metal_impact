class ImportCommandPresenter
	attr_accessor :entries_count, :entries_type

	def initialize(params = {})
		@entries_count = params[:entries_count]
		@entries_type = params[:entries_type]
	end
end