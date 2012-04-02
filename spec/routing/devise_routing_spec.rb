require "spec_helper"

describe "custom routing for devise" do
	describe "routes :" do
		it { get("/signin").should route_to("devise/sessions#new") }
		it { post("/signin").should route_to("devise/sessions#create") }
		it { delete("/signout").should route_to("devise/sessions#destroy") }
	end
	describe "named routes :" do
		it { get(new_user_session_path).should route_to("devise/sessions#new") }
		it { post(user_session_path).should route_to("devise/sessions#create") }
		it { delete(destroy_user_session_path).should route_to("devise/sessions#destroy") }
	end
end