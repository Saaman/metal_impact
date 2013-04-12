require "spec_helper"

describe MusicGenresController do
  describe "routing" do

    it "routes to #search" do
      get("/music_genres/search").should route_to("music_genres#search")
      get(search_music_genres_path).should route_to("music_genres#search")
    end
  end
end
