require 'spec_helper'

#######################################################################################
shared_examples "common registrations actions for signed-in users" do
  describe "GET 'new'" do
  	before { get :new }
  	its_access_is "unauthorized"
  end
  describe "GET 'edit'" do
  	before { get :edit }
		it  { should render_template(:edit) }
  end
  describe "PUT 'update'" do
  	let(:fake_user) { FactoryGirl.build(:user) }
  	before { put :update, {user: {email: fake_user.email, current_password: user.password} } }
		it "should update own registration" do
  		should redirect_to root_path
  		flash[:notice].should_not be_nil
  	end
  end
end
#######################################################################################



describe Users::RegistrationsController do
	subject { response }
	before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

	context "anonymous user" do
		describe "DELETE 'destroy'" do
			before { delete :destroy }
			its_access_is "protected"
	  end
	  describe "GET 'new'" do
	  	before { get :new }
			it { should render_template(:new) }
	  end
	  describe "GET 'edit'" do
	  	before { get :edit }
	  	its_access_is "protected"
	  end
	  describe "PUT 'udate'" do
	  	let(:fake_user) { FactoryGirl.build(:user) }
	  	before { put :update, {user: fake_user.attributes} }
	  	its_access_is "protected"
	  end
	end

  #######################################################################################

	context "signed-in user" do
		login_user
		describe "DELETE 'destroy'" do
			before { delete :destroy }
			it "should delete own registration" do
	  		should redirect_to root_path
	  		User.exists?(user.id).should be_false
	  	end
	  end
  	it_should_behave_like "common registrations actions for signed-in users" do
			login_user
	  end
	end

  #######################################################################################

	context "admin user" do
  	login_admin
		describe "DELETE 'destroy'" do
			before { delete :destroy }
			its_access_is "unauthorized"
		end
		it_should_behave_like "common registrations actions for signed-in users"
	end
end




