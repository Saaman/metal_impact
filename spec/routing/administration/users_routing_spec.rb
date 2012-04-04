require "spec_helper"

describe "Routing for Administration::Users controller" do
	describe "routes :" do
		it { get("/administration/users").should route_to("administration/users#index") }
		it { delete("/administration/users/1").should route_to(controller: "administration/users", action: "destroy", id: "1") }
		it { put("/administration/users/1").should route_to(controller: "administration/users", action: "update", id: "1") }
	end
	describe "named routes :" do
		it { get(administration_users_path).should route_to("administration/users#index") }
		it { delete(administration_user_path(1)).should route_to(controller: "administration/users", action: "destroy", id: "1") }
		it { put(administration_user_path(1)).should route_to(controller: "administration/users", action: "update", id: "1") }
	end
end