require "spec_helper"

describe "Routing for Users::Passwords controller :" do
	describe "routes :" do
		it { get("/users/password/new").should route_to("devise/passwords#new") }
		it { post("/users/password").should route_to("devise/passwords#create") }
		it { get("/users/password/edit").should route_to("devise/passwords#edit") }
		it { put("/users/password").should route_to("devise/passwords#update") }
	end
	describe "named routes :" do
		it { get(new_user_password_path).should route_to("devise/passwords#new") }
		it { post(user_password_path).should route_to("devise/passwords#create") }
		it { get(edit_user_password_path).should route_to("devise/passwords#edit") }
		it { put(user_password_path).should route_to("devise/passwords#update") }
	end
end