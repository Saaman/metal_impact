require "spec_helper"

describe Administration::MonitoringController do

  describe "routing" do
		it "routes to #dashboard" do
			get('dashboard').should route_to('administration/monitoring#dashboard')
			get(dashboard_path).should route_to('administration/monitoring#dashboard')
		end
		it "routes to #toggle_debug" do
			post('toggle_debug').should route_to('administration/monitoring#toggle_debug')
			post(toggle_debug_path).should route_to('administration/monitoring#toggle_debug')
		end
	end
end