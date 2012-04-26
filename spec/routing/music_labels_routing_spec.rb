require "spec_helper"

describe MusicLabelsController do
  describe "routing" do

    it "routes to #new" do
      get("/music_labels/new").should route_to("music_labels#new")
      get(new_music_label_path).should route_to("music_labels#new")
    end

    it "routes to #create" do
      post("/music_labels").should route_to("music_labels#create")
      post(music_labels_path).should route_to("music_labels#create")
    end
  end
end
