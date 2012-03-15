require 'spec_helper'

describe SessionsController do
	subject { response }

	describe "sign in" do
		let(:user) { FactoryGirl.create(:user) }
		context "with invalid information" do
			it "should re-prompt for credentials" do
				post :create, {:email => user.email, :password => "toto"}
				flash[:error].should_not be_empty
				session['remember_token'].should be_nil
				should render_template(:new)
			end
		end
		context "with valid information" do
			before { post :create, {:email => user.email, :password => user.password} }
			
			it "should get signed-in" do
				flash[:error].should be_nil
				session['remember_token'].should_not be_nil
				should redirect_to root_path
			end
			
			it "then sign out" do
				delete :destroy
				should redirect_to root_path
				session['remember_token'].should be_nil
			end
		end
	end

	it "GET /sessions/new" do
		get :new
		should render_template(:new)
	end
end