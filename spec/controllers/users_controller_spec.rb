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
	  	before(:all) { 35.times { FactoryGirl.create(:user) } }
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

  describe "show user" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { get :show, {:id => user.id} }
  	it "should display the user" do
  		assigns(:user).should == user
  		should render_template("show")
  	end
  end

  describe "edit form and actions" do
  	let(:user) { FactoryGirl.create(:user) }
  	let(:user_to_update) { FactoryGirl.build(:user) }
  	context "anonymous user" do
  		it "get EDIT should redirect to sign-in path" do
	  		get :edit, id: user.id
	  		should redirect_to(signin_path)
  		end
  		it "put UPDATE should redirect to sign-in path" do
  			put :update, { id: user.id, user: {email: user_to_update.email, name: user_to_update.name, password: user.password } }
	  		should redirect_to(signin_path)
  		end
  	end
  	context "signed-in but incorrect user" do
  		let(:wrong_user)  { FactoryGirl.create(:user) }
  		before { @controller.sign_in(wrong_user) }
  		it "get EDIT should redirect to root path" do
  			get :edit, {:id=>user.id}
  			should redirect_to(root_path)
  		end
  		it "put UPDATE should redirect to root path" do
  			put :update, { id: user.id, user: {email: user_to_update.email, name: user_to_update.name, password: user.password } }
	  		should redirect_to(root_path)
  		end
  	end
  	context "signed-in and correct user" do
  		before { @controller.sign_in(user) }
  		it "get EDIT should render the update form" do
  			get :edit, {:id=>user.id}
  			assigns(:user).should == user
  			should render_template(:edit)
  		end
  		it "put UPDATE should update user and redirect to show path" do
  			put :update, { id: user.id, user: {email: user_to_update.email, name: user_to_update.name, password: user.password } }
	  		should redirect_to(user_path(user))
	  		updated_user = User.find(user.id)
	  		updated_user.email.should == user_to_update.email
	  		updated_user.name.should == user_to_update.name
  		end
  		it "put UPDATE with wrong password should show auth error" do
  			put :update, { id: user.id, user: {email: user_to_update.email, name: user_to_update.name, password: "wrongpassword" } }
  			should render_template(:edit)
  			flash[:error].should_not be_empty
  		end
  		it "put UPDATE with blank infos should show model errors" do
  			put :update, { id: user.id, user: {email: "", name: "", password: user.password } }
  			assigns(:user).errors.count.should > 0
  			should render_template(:edit)
  		end
  	end
  end
end