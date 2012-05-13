require 'spec_helper'

#######################################################################################
shared_examples "users administration has access unauthorized" do
  describe "GET 'index'" do
    before { get :index }
    its_access_is "unauthorized"
  end

   describe "DELETE 'destroy'" do
     let(:user_to_destroy) { FactoryGirl.create(:user) }
     before { delete :destroy, id: user_to_destroy.id }
     its_access_is "unauthorized"
   end

   describe "PUT 'update'" do
     let(:user_to_update) { FactoryGirl.create(:user) }
     before { put :update, id: user_to_update.id }
     its_access_is "unauthorized"
   end
end
#######################################################################################

describe Administration::UsersController do
  subject { response }

  context "anonymous user :" do
    it_should_behave_like "users administration has access unauthorized"
  end

  #######################################################################################

  context "signed-in user :" do
    it_should_behave_like "users administration has access unauthorized" do
      login_user
    end
  end

  #######################################################################################

  context "admin user :" do
    login_admin
    describe "GET 'index'" do
      before(:all) { 50.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }
      let(:first_page)  { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }
      it "should return the first page of users" do
        get :index
        should render_template("index")
        users = assigns(:users)
        users.should have(first_page.length).items
        users.count.should == User.count
        first_page.each do |item|
          users.should include(item)
        end
      end
      it "should return the second page of users" do
        get :index, { :page => 2 }
        should render_template("index")
        users = assigns(:users)
        users.length.should == second_page.length
        users.count.should == User.count
        users.should have(second_page.length).items
        second_page.each do |item|
          users.should include(item)
        end
      end
    end
    describe "DELETE 'destroy'" do
      describe "destroy the corresponding user :" do
        let(:user_to_destroy) { FactoryGirl.create(:user) }
        before { delete :destroy, id: user_to_destroy.id }
        it { User.exists?(user_to_destroy.id).should be_false }
        its(:code) { should  == "200" }
      end
      describe "except admin cannot delete himself :" do
        before { delete :destroy, id: user.id }
        its_access_is "unauthorized"
      end
      describe "should show error and redirect to previous when trying to delete unknown user" do
        before do
          get :index
          delete :destroy, id: "300"
        end
        it { should redirect_to administration_users_path }
        specify { flash[:error].should include("Couldn't find User with id=300") }
      end
    end
    describe "PUT 'update :'" do
      let(:user_to_update) { FactoryGirl.create(:user) }
      describe "update the role of the corresponding user" do
        before { put :update, {id: user_to_update.id, user: {role: :admin}} }
        it { should redirect_to (administration_users_path) }
        it {user_to_update.reload.admin?.should be_true }
      end
      describe "should not update email and password" do
        let(:other_user) { FactoryGirl.build(:user) }
        before { put :update, {id: user_to_update.id, user: other_user.attributes} }
        it { user_to_update.reload.email.should == user_to_update.email }
        it { user_to_update.reload.password.should == user_to_update.password }
      end
    end
  end
end