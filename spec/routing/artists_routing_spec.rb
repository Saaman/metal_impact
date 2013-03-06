require "spec_helper"

describe ArtistsController do
  describe "routing" do

    it_should_behave_like "routes for vote" do
      let(:resources) { "artists" }
    end

    it "routes to #index" do
      get("/artists").should route_to("artists#index")
      get(artists_path).should route_to("artists#index")
    end

    it "routes to #new" do
      get("/artists/new").should route_to("artists#new")
      get(new_artist_path).should route_to("artists#new")
    end

    it "routes to #show" do
      get("/artists/1").should route_to("artists#show", :id => "1")
      get(artist_path(1)).should route_to("artists#show", :id => "1")
    end

    # it "routes to #edit" do
    #   get("/artists/1/edit").should route_to("artists#edit", :id => "1")
    #   get(edit_artist_path(1)).should route_to("artists#edit", :id => "1")
    # end

    it "routes to #create" do
      post("/artists").should route_to("artists#create")
      post(artists_path).should route_to("artists#create")
    end

    # it "routes to #update" do
    #   put("/artists/1").should route_to("artists#update", :id => "1")
    #   put(artist_path(1)).should route_to("artists#update", :id => "1")
    # end

    # it "routes to #destroy" do
    #   delete("/artists/1").should route_to("artists#destroy", :id => "1")
    #   delete(artist_path(1)).should route_to("artists#destroy", :id => "1")
    # end

    #Non default routes
    it "routes to #search" do
      get("/artists/search").should route_to("artists#search")
      get(search_artists_path).should route_to("artists#search")
    end

    it "routes to #smallblock" do
      get("/artists/1/smallblock").should route_to("artists#smallblock", :id => "1")
      get(smallblock_artist_path(1)).should route_to("artists#smallblock", :id => "1")
    end

  end
end
