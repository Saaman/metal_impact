require 'spec_helper'

describe UsersController do
	subject { response }

	describe "sign up form" do
		before { get :new }
		it { should render_template(:new) }
	end

	describe "sign up action" do
		describe "with invalid information" do
			it "should return errors" do
				post :create
				assigns(:user).errors.count.should > 0
				should render_template(:new)
			end
		end
		describe "with valid information" do
			let!(:user) { FactoryGirl.build(:user) }
			before { post :create, :user => { :email => user.email, :name => user.name, :password => "foobar", :password_confirmation => "foobar"} }
			
			it "should create the user without errors" do
				assigns(:user).errors.count.should == 0
				User.all.count.should == 1
				User.first.email.should == user.email
			end
			specify { session.should be_signed_in }
		end
	end
end