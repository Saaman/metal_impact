require "spec_helper"

describe AlbumsController do
  describe "routing" do

    it_should_behave_like "routes for vote" do
      let(:resources) { "albums" }
    end

    it "routes to #index" do
      get("/albums").should route_to("albums#index")
      get(albums_path).should route_to("albums#index")
    end

    it "routes to #new" do
      get("/albums/new").should route_to("albums#new")
      get(new_album_path).should route_to("albums#new")
    end

    it "routes to #show" do
      get("/albums/1").should route_to("albums#show", :id => "1")
      get(album_path(1)).should route_to("albums#show", :id => "1")
    end

    it "routes to #edit" do
      get("/albums/1/edit").should route_to("albums#edit", :id => "1")
      get(edit_album_path(1)).should route_to("albums#edit", :id => "1")
    end

    it "routes to #create" do
      post("/albums").should route_to("albums#create")
      post(albums_path).should route_to("albums#create")
    end

    it "routes to #update" do
      put("/albums/1").should route_to("albums#update", :id => "1")
      put(album_path(1)).should route_to("albums#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/albums/1").should route_to("albums#destroy", :id => "1")
      delete(album_path(1)).should route_to("albums#destroy", :id => "1")
    end

  end
end
