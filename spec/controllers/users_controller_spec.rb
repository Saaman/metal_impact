require 'spec_helper'

describe UsersController do
	subject { response }

	describe "sign up form" do
		before { get :new }
		it { should render_template(:new) }
	end

	describe "sign up action" do
		context "with invalid information" do
			it "should return errors" do
				post :create
				assigns(:user).errors.count.should > 0
				should render_template(:new)
			end
		end
		context "with valid information" do
			let!(:user) { FactoryGirl.build(:user) }
			before { post :create, :user => { :email => user.email, :name => user.name, :password => "foobar", :password_confirmation => "foobar"} }
			
			it "should create the user without errors" do
				assigns(:user).errors.count.should == 0
				User.all.count.should == 1
				created_user = User.first
				created_user.email.should == user.email
			end
			it { should redirect_to User.first }
			specify { session.should be_signed_in }
		end
	end

	describe "list users" do
    context "anonymous user" do
    	before { get :index }
	    it { should redirect_to signin_path }
	  end
	  context "signed_in user" do
	  	before(:all) { 50.times { FactoryGirl.create(:user) } }
	    after(:all)  { User.delete_all }
	  	let(:user) { FactoryGirl.create(:user) }
	    let(:first_page)  { User.paginate(page: 1) }
	    let(:second_page) { User.paginate(page: 2) }

	  	before { @controller.sign_in(user) }

	  	it "should return the first page of users" do
	  		get :index
	  		users = assigns(:users)
	  		users.should have(first_page.length).items
	  		users.count.should == User.count
	  		first_page.each do |item|
	  			users.should include(item)
	  		end
	  	end
	  	it "should return the second page of users" do
	  		get :index, { :page => 2 }
	  		users = assigns(:users)
	  		users.length.should == second_page.length
	  		users.count.should == User.count
	  		users.should have(second_page.length).items
	  		second_page.each do |item|
	  			users.should include(item)
	  		end
	  	end
	  end
  end
end