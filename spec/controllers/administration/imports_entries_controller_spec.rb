require 'spec_helper'

describe Administration::ImportEntriesController do
	#Initialization stuff
  stub_abilities
  set_referer

  subject { response }

  describe "GET edit :" do
  	describe "(unauthorized)" do
      let (:entry) { FactoryGirl.create(:entry) }
			before { get :edit, {id: entry.id} }
			its_access_is "unauthorized"
  	end

  	describe "(authorized)" do
      let (:entry) { FactoryGirl.create(:entry) }
  		before(:each) { @ability.can :edit, Import::Entry }
  		it "should display edit form" do
  			get :edit, {id: entry.id}
  			assigns(:entry).should == entry
        should render_template("edit")
  		end
	  end
  end

  describe "PUT update :" do
  	let (:entry) { FactoryGirl.create(:entry) }
  	describe "(unauthorized)" do
			before { put :update, {id: entry.id} }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
  		before(:each) { @ability.can :update, Import::Entry }
  		describe "it should render edit on failure" do
  			before { put :update, {id: entry.id, :import_entry => {:data => "{toto: 'tata'"}} }
        specify { assigns(:entry).should == entry }
		  	it { should render_template("edit") }
  		end
      describe "on success" do
        before { put :update, {id: entry.id, :import_entry => {:data => {one: "two"}}} }
        its(:code) { should == '200' }
      end
	  end
  end
end
