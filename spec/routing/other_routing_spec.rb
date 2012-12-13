require "spec_helper"

describe "other routes" do
	describe "routing for Home controller" do
		let(:image_url) { "http://www.metal-impact.com/modules/Reviews/images/zapruder_straightfromthehorsesmouth.jpg" }
		it "routes to #index" do
			get("/").should route_to("home#index")
			get(root_path).should route_to("home#index")
		end
		it "routes to #show_image" do
			get("show_image").should route_to("home#show_image", :format => "js")
			get(show_image_path).should route_to("home#show_image", :format => "js")
		end
	end

	describe "routing for Dashboard controller" do
		it "routes to #show" do
			get('dashboard').should route_to('administration/monitoring#dashboard')
			post('dashboard').should route_to('administration/monitoring#dashboard')
			get(dashboard_path).should route_to('administration/monitoring#dashboard')
			post(dashboard_path).should route_to('administration/monitoring#dashboard')
		end
	end
end