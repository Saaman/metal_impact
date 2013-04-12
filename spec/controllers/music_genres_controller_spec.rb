require 'spec_helper'

describe MusicGenresController do
  stub_abilities
  set_referer

  subject { response }

  describe "GET search :" do
    let(:music_genres) { FactoryGirl.create_list :music_genre, 10 }
    let(:music_genre) { music_genres[0] }
    describe "(unauthorized)" do
      before { get :search, {search_pattern: "rot"} }
      its_access_is "unauthorized"
    end

    describe "(authorized)" do
      before(:each) { @ability.can :search, MusicGenre }
      it "should retrieve music genre" do
        get :search, search_pattern: music_genre.name.split(' ')[0], :format => :json
        assigns(:music_genres).should include(music_genre)
      end
    end
  end
end
