require "spec_helper"

describe Administration::ContributionsController do
  describe "routing" do

    it "routes to #index" do
      get("/administration/contributions").should route_to("administration/contributions#index")
      get(administration_contributions_path).should route_to("administration/contributions#index")
    end

    it "routes to #show" do
      get("/administration/contributions/1").should route_to("administration/contributions#show", id: '1')
      get(administration_contribution_path(1)).should route_to("administration/contributions#show", id: '1')
    end

    it "routes to #approve" do
      put("/administration/contributions/1/approve").should route_to("administration/contributions#approve", id: '1')
      put(approve_administration_contribution_path(1)).should route_to("administration/contributions#approve", id: '1')
    end

    it "routes to #refuse" do
      put("/administration/contributions/1/refuse").should route_to("administration/contributions#refuse", id: '1')
      put(refuse_administration_contribution_path(1)).should route_to("administration/contributions#refuse", id: '1')
    end
  end
end
