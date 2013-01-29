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
  			assigns(:source_files).first.created_at.should > assigns(:source_files).last.created_at
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
  		describe "it should render show" do
  			before do
  				Import::SourceFile.any_instance.should_receive(:refresh_status)
  				get :show, {id: source_file.id}
  			end
		  	it { should render_template("show") }
		  	specify { assigns(:source_file).should == source_file }
  		end
	  end
  end

  describe "PUT update :" do
    let(:source_file) { FactoryGirl.create(:source_file) }
    describe "(unauthorized)" do
      before { put :update, {id: source_file.id} }
      its_access_is "unauthorized"
    end
    describe "(authorized)" do
      before do
        @ability.can :update, Import::SourceFile
        Import::SourceFile.any_instance.stub(:load_file).and_return(true)
      end
      before { put :update, {id: source_file.id, :import_source_file => {:source_type => :metal_impact}} }
      it "redirects to the source file" do
        response.should redirect_to administration_import_path(source_file)
      end
      it "updates the source_file" do
        assigns(:source_file).source_type.should == :metal_impact
      end
    end
  end
end
