class Administration::MonitoringController < ApplicationController
	authorize_resource :class => false
	respond_to :html

	def dashboard
		allow_debug = manage_debug_mode params[:allow_debug]
		@dashboard = DashboardPresenter.new(allow_debug: allow_debug)
		respond_with @dashboard
	end

	private
		def manage_debug_mode(value)
			#value is empty => means no parameters POSTed
			Rails.cache.fetch(:allow_debug) || false if value.nil?
	    Rails.cache.write(:allow_debug, value, :expires_in => 1.day)
	    value
	  end
end