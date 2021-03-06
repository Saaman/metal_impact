require 'spec_helper'

describe Administration::ContributionsController do
	#Initialization stuff
  stub_abilities
  set_referer

  subject { response }

  describe "GET index :" do
  	describe "(unauthorized)" do
			before { get :index }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
      before(:all) do
        40.times do
        	FactoryGirl.create(:contribution)
        end
      end
      after(:all) { Contribution.delete_all }
  		before(:each) { @ability.can :index, Contribution }
  		it "should display 20 source files" do
  			get :index
  			assigns(:contributions).size.should == 20
  		end
  		it "should sort by created_at asc" do
  			get :index
  			assigns(:contributions).first.created_at.should < assigns(:contributions).last.created_at
  		end
	  end
	end

  describe "GET show :" do
    let(:contribution) { FactoryGirl.create(:contribution) }
    before { contribution.save! }
    describe "(unauthorized)" do
      before { get :show, {id: contribution.id} }
      its_access_is "unauthorized"
    end
    describe "(authorized)" do
      before do
        @ability.can :index, Contribution
        get :show, {id: contribution.id}
      end
      specify { assigns(:contribution).should == contribution }
    end
  end
end