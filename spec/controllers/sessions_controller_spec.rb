require 'spec_helper'

describe SessionsController do
	subject { response }

	describe "sign in" do
		let(:user) { FactoryGirl.create(:user) }
		context "with invalid information" do
			it "should re-prompt for credentials" do
				post :create, {:email => user.email, :password => "toto"}
				flash[:error].should_not be_empty
				session.should_not be_signed_in
				should render_template(:new)
			end
		end
		context "with valid information" do
			before { post :create, {:email => user.email, :password => user.password} }
			
			it "should get signed-in" do
				flash[:error].should be_nil
				session.should be_signed_in
				should redirect_to root_path
			end
		end
	end

	describe "sign out" do
		context "anonymous user" do
			it "should redirect to sign in page" do
				delete :destroy
				should redirect_to root_path
				session.should_not be_signed_in
			end
		end
		context "signed-in user" do
			let(:user) { FactoryGirl.create(:user) }
			it "should sign out" do
				@controller.sign_in(user)
				delete :destroy
				should redirect_to root_path
				session.should_not be_signed_in
			end
		end
	end

	it "GET /sessions/new" do
		get :new
		should render_template(:new)
	end
end