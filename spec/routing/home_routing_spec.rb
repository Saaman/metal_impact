require "spec_helper"

describe "routing for Home controller" do
	describe "routes :" do
		it { get("/").should route_to("home#index") }
	end
	describe "named routes :" do
		it { get(root_path).should route_to("home#index") }
	end
end