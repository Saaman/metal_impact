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

   it "routes to #prepare" do
      put("/administration/imports/1/prepare").should route_to("administration/imports#prepare", :id => "1")
      put(prepare_administration_import_path(1)).should route_to("administration/imports#prepare", :id => "1")
    end

    describe 'nested routing for failures' do
      it 'should route to #index' do
        get("/administration/imports/1/failures").should route_to('administration/import_failures#index', :import_id => '1')
        get(administration_import_failures_path(1)).should route_to('administration/import_failures#index', :import_id => '1')
      end

      it 'should route to #clear' do
        delete("/administration/imports/1/failures/clear").should route_to('administration/import_failures#clear', :import_id => '1')
        delete(clear_administration_import_failures_path(1)).should route_to('administration/import_failures#clear', :import_id => '1')
      end
    end

  end
end