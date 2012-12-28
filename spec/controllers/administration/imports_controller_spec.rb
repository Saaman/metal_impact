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

  describe "GET show :" do
  	let(:source_file) { FactoryGirl.create(:source_file) }
  	describe "(unauthorized)" do
			before { get :show, {id: source_file.id} }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
  		before(:each) { @ability.can :show, Import::SourceFile }
  		describe "when source_file is not new, render show" do
  			before do
  				Import::SourceFile.any_instance.stub(:new?).and_return(false)
  				get :show, {id: source_file.id}
  			end
		  	it { should render_template("show") }
		  	specify { assigns(:source_file).should == source_file }
  		end
  		describe "when source_file is new, should redirect to edit" do
		  	before { get :show, {id: source_file.id} }
		  	it { should redirect_to edit_administration_import_path(source_file) }
		  end
	  end
  end

  describe "GET edit :" do
  	let(:source_file) { FactoryGirl.create(:source_file) }
  	describe "(unauthorized)" do
			before { get :edit, {id: source_file.id} }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
  		before(:each) { @ability.can :edit, Import::SourceFile }
  		describe "when source_file is not new, redirect to show" do
  			before do
  				Import::SourceFile.any_instance.stub(:new?).and_return(false)
  				get :edit, {id: source_file.id}
  			end
  			it { should redirect_to administration_import_path(source_file) }
  		end
  		describe "when source_file is new, render edit" do
		  	before { get :edit, {id: source_file.id} }
		  	it { should render_template("edit") }
		  	specify { assigns(:source_file).should == source_file }
		  end
	  end
  end
end
