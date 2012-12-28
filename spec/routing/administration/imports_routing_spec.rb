require "spec_helper"

describe Administration::ImportsController do
  describe "routing" do

    it "routes to #index" do
      get("/administration/imports").should route_to("administration/imports#index")
      get(administration_imports_path).should route_to("administration/imports#index")
    end

    it "routes to #show" do
      get("/administration/imports/1").should route_to("administration/imports#show", :id => "1")
      get(administration_import_path(1)).should route_to("administration/imports#show", :id => "1")
    end

    it "routes to #update" do
      put("/administration/imports/1").should route_to("administration/imports#update", id: "1")
      put(administration_import_path(1)).should route_to("administration/imports#update", id: "1")
    end

   it "routes to #edit" do
      get("/administration/imports/1/edit").should route_to("administration/imports#edit", :id => "1")
      get(edit_administration_import_path(1)).should route_to("administration/imports#edit", :id => "1")
    end

  end
end