require 'spec_helper'

describe Users::RegistrationsController do
	subject { response }
	before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

	context "anonymous user" do
		describe "delete own registration :" do
			let(:user_to_destroy) {FactoryGirl.create(:user) }
			it "would be nonsense" do
	  		delete :destroy
	  		should redirect_to new_user_session_path
	  		User.exists?(user_to_destroy.id).should be_true
	  	end
	  end
	  describe "register :" do
			it "should be allowed" do
	  		get :new
	  		should render_template(:new)
	  	end
	  end
	  describe "edit registration :" do
			it "should not be allowed" do
	  		get :edit
	  		should redirect_to new_user_session_path
	  	end
	  end
	  describe "update registration :" do
	  	let(:fake_user) { FactoryGirl.build(:user) }
			it "should not be allowed" do
	  		put :update, {user: fake_user.attributes}
	  		should redirect_to new_user_session_path
	  	end
	  end
	end


	context "signed-in user" do
		login_user
		describe "delete own registration :" do
			it "should be able to delete himself" do
	  		delete :destroy
	  		should redirect_to root_path
	  		User.exists?(user.id).should be_false
	  	end
	  end
	  describe "edit registration :" do
			it "should be allowed" do
	  		get :edit
	  		should render_template(:edit)
	  	end
	  end
	  describe "update registration :" do
	  	let(:fake_user) { FactoryGirl.build(:user) }
			it "should be allowed" do
	  		put :update, {user: {email: fake_user.email, current_password: user.password} }
	  		should redirect_to root_path
	  		flash[:notice].should_not be_nil
	  	end
	  end
	end


	context "admin user" do
  	login_admin
		describe "delete own registration :" do
			it "should not be able to delete himself" do
	  		delete :destroy
	  		should redirect_to root_path
	  		User.exists?(user.id).should be_true
	  		flash[:error].should_not be_nil
	  		flash[:error].should include(forbidden_for_admins_string)
	  	end
	  end
	end
end