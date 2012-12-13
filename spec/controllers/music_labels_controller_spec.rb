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
  set_referer

  subject { response }

  # context "anonymous user :" do
  #   it_should_behave_like "music_labels : access denied on restricted actions"
  # end

  #######################################################################################

  # context "signed-in user :" do
  #   it_should_behave_like "music_labels : access denied on restricted actions" do
  #     login_user
  #   end
  # end

  ######################################################################################

  describe "new way tests" do
    stub_abilities
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
end