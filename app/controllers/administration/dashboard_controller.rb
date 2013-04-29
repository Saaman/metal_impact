class Administration::DashboardController < ApplicationController
	authorize_resource :class => false
	respond_to :html

	def index
		@dashboard = DashboardPresenter.new(allow_debug: can_debug?)
		@contributions_count = Contribution.at_state(:pending).count
		respond_with @dashboard
	end

	def toggle_debug
		toggle_allow_debug()
		redirect_to :action => :index
	end

	private
		def toggle_allow_debug
			Rails.cache.write(:allow_debug, !can_debug?, :expires_in => 1.day)
		end
end
