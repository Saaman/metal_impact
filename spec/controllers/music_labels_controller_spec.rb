require 'spec_helper'

#######################################################################################
shared_examples "music_labels : access denied on restricted actions" do
  describe "GET new" do
    before { get :new }
    its_access_is "unauthorized"
  end
end
#######################################################################################

describe MusicLabelsController do
  stub_abilities
  before(:each) do
    request.env["HTTP_REFERER"] = root_path
  end
  
  subject { response }

  context "anonymous user :" do
    it_should_behave_like "music_labels : access denied on restricted actions"
  end

  #######################################################################################

  context "signed-in user :" do
    it_should_behave_like "music_labels : access denied on restricted actions" do
      login_user
    end
  end

  ###################################################################################### 

  context "admin user :" do
    
    login_admin

    describe "GET new" do
      it "assigns a new music label as @music_label" do
        get :new
        assigns(:music_label).should be_a_new(MusicLabel)
      end
    end
  end


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
end