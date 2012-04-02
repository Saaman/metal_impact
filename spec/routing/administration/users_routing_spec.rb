require "spec_helper"

describe "Routing for Administration::Users controller" do
	describe "routes :" do
		it { get("/administration/users").should route_to("administration/users#index") }
		it { delete("/administration/users/1").should route_to(controller: "administration/users", action: "destroy", id: "1") }
		it { get("/administration/users/filter").should route_to("administration/users#filter") }
	end
	describe "named routes :" do
		it { get(administration_users_path).should route_to("administration/users#index") }
		it { delete(administration_user_path(1)).should route_to(controller: "administration/users", action: "destroy", id: "1") }
		it { get(filter_administration_users_path).should route_to("administration/users#filter") }
	end
end