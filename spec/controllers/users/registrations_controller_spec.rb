require 'spec_helper'

describe Users::RegistrationsController do
	subject { response }
	before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "delete user :" do
  	let(:user_to_destroy) {FactoryGirl.create(:user) }
  	context "anonymous user" do
  		it "should not be able to delete a user" do
	  		delete :destroy, id: user_to_destroy.id
	  		should redirect_to new_user_session_path
	  		User.exists?(user_to_destroy.id).should be_true
	  	end
  	end
  	context "signed-in user" do
  		login_user
  		it "should not be able to delete any user" do
	  		delete :destroy, id: user_to_destroy.id
	  		should redirect_to root_path
	  		#flash[:error].should_not be_empty
	  		User.exists?(user_to_destroy.id).should be_true
	  	end
	  	it "should be able to delete himself" do
	  		delete :destroy, id: user.id
	  		should redirect_to root_path
	  		#flash[:success].should_not be_empty
	  		User.exists?(user.id).should be_false
	  	end
  	end
  	context "admin user" do
  		login_admin
  		it "should not be able to delete himself" do
	  		delete :destroy, id: user.id
	  		should redirect_to root_path
	  		flash[:error].should_not be_empty
	  		User.exists?(user.id).should be_true
	  	end
	  	it "should be able to delete any user" do
	  		delete :destroy, id: user_to_destroy.id
	  		#should redirect_to users_path
	  		#flash[:success].should_not be_empty
	  		User.exists?(user_to_destroy.id).should be_false
	  	end
  	end
  end
end