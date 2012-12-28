require 'spec_helper'

describe Administration::ImportsController do
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
        40.times { FactoryGirl.create(:source_file) }
      end
  		before(:each) { @ability.can :index, Import::SourceFile }
  		it "should display 40 source files" do
  			get :index
  			assigns(:source_files).size.should == 40
  		end
  		it "should sort by created_dt desc" do
  			get :index
  			assigns(:source_files).first.created_at.should > assigns(:source_files)[10].created_at
  		end
	  end
  end
end
