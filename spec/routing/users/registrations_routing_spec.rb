require "spec_helper"

describe "Routing for Users::Registrations controller :" do
	describe "routes :" do
		it { post("/users").should route_to("users/registrations#create") }
		it { post("/signup").should route_to("users/registrations#create") }
		it { get("/signup").should route_to("users/registrations#new") }
		it { get("/users/edit").should route_to("users/registrations#edit") }
		it { get("/users/sign_up").should route_to("users/registrations#new") }
		it { put("/users").should route_to("users/registrations#update") }
		it { delete("/users").should route_to("users/registrations#destroy") }
		it { get("/users/cancel").should route_to("users/registrations#cancel") }
		it { get("/users/is-pseudo-taken").should route_to("users/registrations#is_pseudo_taken") }
	end
	describe "named routes :" do
		it { get(new_user_registration_path).should route_to("users/registrations#new") }
		it { post(user_registration_path).should route_to("users/registrations#create") }
		it { get(edit_user_registration_path).should route_to("users/registrations#edit") }
		it { put(user_registration_path).should route_to("users/registrations#update") }
		it { delete(user_registration_path).should route_to("users/registrations#destroy") }
		it { get(cancel_user_registration_path).should route_to("users/registrations#cancel") }
		it { get(is_pseudo_taken_user_registration_path).should route_to("users/registrations#is_pseudo_taken") }
	end
end