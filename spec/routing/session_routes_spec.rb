require "spec_helper"

describe "routes to the sessions controller" do
	it "GET index forbidden" do
		get(sessions_path).should_not be_routable
	end
	it "PUT update forbidden" do
		put(sessions_path).should_not be_routable
	end
	it 'session#new as signin' do
		get(signin_path).should route_to("sessions#new")
	end
	it 'session#destroy as signout' do
		delete(signout_path).should route_to("sessions#destroy")
	end
end

describe "routes to the users controller" do
end