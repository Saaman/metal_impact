require "spec_helper"

describe Administration::ImportEntriesController do
  describe "routing" do

    it "routes to #edit" do
      get("/administration/import_entries/1/edit").should route_to("administration/import_entries#edit", :id => '1')
      get(edit_administration_import_entry_path(1)).should route_to("administration/import_entries#edit", :id => '1')
    end
    it "routes to #update" do
      put("/administration/import_entries/1").should route_to("administration/import_entries#update", id: '1')
      put(administration_import_entry_path(1)).should route_to("administration/import_entries#update", id: '1')
    end

  end
end