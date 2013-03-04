require "spec_helper"

describe Administration::DashboardController do

  describe "routing" do
		it "routes to #dashboard" do
			get('dashboard').should route_to('administration/dashboard#index')
			get(dashboard_path).should route_to('administration/dashboard#index')
		end
		it "routes to #toggle_debug" do
			post('toggle_debug').should route_to('administration/dashboard#toggle_debug')
			post(toggle_debug_path).should route_to('administration/dashboard#toggle_debug')
		end
	end
end