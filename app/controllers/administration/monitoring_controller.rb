class Administration::MonitoringController < ApplicationController
	authorize_resource :class => false
	respond_to :html

	def dashboard
		@dashboard = DashboardPresenter.new(allow_debug: can_debug?)
		respond_with @dashboard
	end

	def toggle_debug
		toggle_allow_debug()
		redirect_to :action => :dashboard
	end

	private
		def toggle_allow_debug
			set_debug !can_debug?
		end
end