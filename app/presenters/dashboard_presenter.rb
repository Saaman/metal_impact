class DashboardPresenter
	attr_accessor :allow_debug

	def initialize(params = {})
		params = {} if params.nil?
		@allow_debug = (params[:allow_debug] || false)
	end
end