require "spec_helper"

describe Administration::UsersController do
  describe "routing" do

    it "routes to #index" do
      get("/administration/users").should route_to("administration/users#index")
      get(administration_users_path).should route_to("administration/users#index")
    end

    it "routes to #update" do
      put("/administration/users/1").should route_to(controller: "administration/users", action: "update", id: "1")
      put(administration_user_path(1)).should route_to(controller: "administration/users", action: "update", id: "1")
    end

    it "routes to #destroy" do
      delete("/administration/users/1").should route_to(controller: "administration/users", action: "destroy", id: "1")
      delete(administration_user_path(1)).should route_to(controller: "administration/users", action: "destroy", id: "1")
    end

  end
end