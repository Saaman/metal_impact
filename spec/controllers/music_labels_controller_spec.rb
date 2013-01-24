require 'spec_helper'

describe MusicLabelsController do
  stub_abilities
  set_referer

  subject { response }

  describe "GET smallblock :" do
    let(:music_label) { FactoryGirl.create(:music_label) }
    describe "(unauthorized)" do
      before { get :smallblock, {id: music_label.id} }
      its_access_is "unauthorized"
    end
    describe "(authorized)" do
      before(:each) { @ability.can :smallblock, MusicLabel }
      before { get :smallblock, {id: music_label.id} }
      it { should render_template("smallblock") }
      specify { assigns(:music_label).should == music_label }
    end
  end

  describe "GET search :" do
    let(:music_labels) { FactoryGirl.create_list(:music_label, 10) }
    let(:music_label) { music_labels[0] }
    describe "(unauthorized)" do
      before { get :search, {search_pattern: "rot"} }
      its_access_is "unauthorized"
    end

    describe "(authorized)" do
      before(:each) { @ability.can :search, MusicLabel }
      it "should retrieve music label" do
        get :search, search_pattern: music_label.name.split(' ')[0], :format => :json
        assigns(:music_labels).should include(music_label)
      end
    end
  end
end