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
      it "assigns a new music label as @musicLabel" do
        get :new
        assigns(:musicLabel).should be_a_new(MusicLabel)
      end
    end
  end
end