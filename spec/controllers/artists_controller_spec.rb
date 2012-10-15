require 'spec_helper'

describe ArtistsController do
	#Initialization stuff
  before(:all) do
  	Artist.all.each {|a| a.destroy }
  	30.times { FactoryGirl.create(:artist) }
  	10.times { FactoryGirl.create(:artist, :practice_kind => :writer) }
  end
  stub_abilities
  
  before(:each) do
    request.env["HTTP_REFERER"] = root_path
  end

  subject { response }


  describe "GET search :" do
  	let(:artist) { FactoryGirl.create(:artist) }
  	let(:writer) { FactoryGirl.create(:artist, :practice_kind => :writer) }

  	describe "(unauthorized)" do
			before { get :search, {name_like: "rot"} }
			its_access_is "unauthorized"
  	end
  	
  	describe "(authorized)" do
  		before(:each) { @ability.can :search, Artist }
	  	describe "without product kind" do
	  		it "should retrieve band" do
	  			get :search, name_like: artist.name.split(' ')[0], :format => :json
	  			assigns(:artists).should include(artist)
	  		end
	  		it "should retrieve writer" do
	  			get :search, name_like: writer.name.split(' ')[0], :format => :json
	  			assigns(:artists).should include(writer)
	  		end
	  	end
	  	describe "with product kind" do
	  		it "'album', should retrieve band" do
	  			get :search, name_like: artist.name.split(' ')[0], "for-product" => "album", :format => :json
	  			assigns(:artists).should include(artist)
	  		end
	  		it "'album', should not retrieve writer" do
	  			get :search, name_like: writer.name.split(' ')[0], "for-product" => "album", :format => :json
	  			assigns(:artists).should_not include(writer)
	  		end
	  		it "'interview', should retrieve band" do
	  			get :search, name_like: artist.name.split(' ')[0], "for-product" => "interview", :format => :json
	  			assigns(:artists).should include(artist)
	  		end
	  		it "'interview', should retrieve writer" do
	  			get :search, name_like: writer.name.split(' ')[0], "for-product" => "interview", :format => :json
	  			assigns(:artists).should include(writer)
	  		end
	  	end
	  end
  end

  describe "GET index :" do
  	describe "(unauthorized)" do
			before { get :index }
			its_access_is "unauthorized"
  	end
  	
  	describe "(authorized)" do
  		before(:each) { @ability.can :index, Artist }
  		it "should 30 display artists" do
  			get :index
  			assigns(:artists).size.should == 30
  		end
  		it "should have a second page to display" do
  			get :index, page: 2
  			assigns(:artists).size.should > 0
  		end
  		it "should sort by updated_dt desc" do
  			get :index
  			assigns(:artists).first.updated_at.should > assigns(:artists)[10].updated_at
  		end
	  end
  end

  describe "GET smallblock :" do
  	let(:artist) { FactoryGirl.create(:artist) }
  	describe "(unauthorized)" do
			before { get :smallblock, {id: artist.id} }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
  		before(:each) { @ability.can :smallblock, Artist }
	  	before { get :smallblock, {id: artist.id} }
	  	it { should render_template("smallblock") }
	  	specify { assigns(:artist).should == artist }
	  end
  end

  describe "GET show :" do
  	let(:artist) { FactoryGirl.create(:artist) }
  	describe "(unauthorized)" do
			before { get :show, {id: artist.id} }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
  		before(:each) { @ability.can :show, Artist }
	  	before { get :show, {id: artist.id} }
	  	it { should render_template("show") }
	  	specify { assigns(:artist).should == artist }
	  end
	  describe "(RecordNotFound exception)" do
  		before(:each) { @ability.can :show, Artist }
	  	before { get :show, {id: 10000} }
	  	it { should redirect_to root_path }
	  end
  end

  describe "GET new :" do
  	describe "(unauthorized)" do
			before { get :new, :format => :js }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
  		before(:each) { @ability.can :create, Artist }
	  	before { get :new, :format => :js }
	  	it { should render_template("new") }
	  	specify { assigns(:artist).should be_new_record }
	  end
  end

end