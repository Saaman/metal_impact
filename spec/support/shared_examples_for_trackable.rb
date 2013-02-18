require "rspec/expectations"
require "set"

shared_examples "trackable model" do

	describe "attributes and methods" do
    #attributes
    it { should respond_to(:activities) }
    it { should respond_to(:owner_pseudo)}
  end

  describe 'Methods :' do
  	its(:owner_pseudo) { should be_nil }
  	its(:owner) { should be_nil }
	  	describe 'owner should be the user that saved the entity ' do
	  	let(:user) { FactoryGirl.create :user }
	  	before do
	  		trackable.activity owner: user
	  		trackable.save!
	  	end
	  	its(:owner_pseudo) { should == user.pseudo }
	  	its(:owner) { should == user }
	  end
  end
end