require 'spec_helper'

#######################################################################################
shared_examples "common sessions actions for signed-in users" do
  describe "GET 'new'" do
  	before { get :new }
  	it_should_behave_like "already signed in"
  end
  describe "POST 'create'" do
  	let(:user_attrs) { FactoryGirl.attributes_for(:user) }
  	before { post :create, :user => user_attrs }
  	it_should_behave_like "already signed in"
  end
  describe "DELETE 'destroy'" do
  	before { delete :destroy }
  	it "should disconnect the user" do
  		should redirect_to root_path
  		flash[:notice].should_not be_nil
  		@controller.current_user.should be_nil
  	end
  end
end
#######################################################################################


describe Users::SessionsController do
	subject { response }
	before(:each) do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		request.env["HTTP_REFERER"] = root_path
	end

	context "anonymous user" do
		describe "DELETE 'destroy'" do
			before { delete :destroy }
			it {should redirect_to root_path}
	  end
	  describe "GET 'new'" do
	  	before { get :new, :format => :js }
			it { should render_template(:new) }
	  end
	  describe "POST 'create'" do
	  	let(:user) { FactoryGirl.create(:user) }
	  	describe "with valid password" do
	  		before { post :create, :user => {email: user.email, password: user.password}, :format => :js }
	  		it "should be signed in" do
		  		should be_success
	  			flash[:notice].should_not be_nil
	  			@controller.current_user.should_not be_nil
	  		end
	  	end
	  	describe "with invalid password" do
	  		before { post :create, :user => {email: user.email, password: "toto"}, :format => :js }
	  		it "should show authentication error" do
		  		should render_template(:new)
	  			flash[:error].should_not be_nil
	  			@controller.current_user.should be_nil
	  		end
	  	end
	  end
	end

  #######################################################################################

	context "signed-in user" do
		login_user
  	it_should_behave_like "common sessions actions for signed-in users" do
			login_user
	  end
	end

  #######################################################################################

	context "admin user" do
		login_user :admin
  	it_should_behave_like "common sessions actions for signed-in users" do
			login_user :admin
	  end
	end
end




