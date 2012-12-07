require "spec_helper"

describe "Routing for Users::Sessions controller :" do
	describe "routes :" do
		it { delete("/logout").should route_to("devise/sessions#destroy") }
		it { get("/login").should route_to("devise/sessions#new") }
		it { post("/login").should route_to("devise/sessions#create") }
	end
	describe "named routes :" do
		it { delete(destroy_user_session_path).should route_to("devise/sessions#destroy") }
		it { get(new_user_session_path).should route_to("devise/sessions#new") }
		it { post(user_session_path).should route_to("devise/sessions#create") }
	end
end