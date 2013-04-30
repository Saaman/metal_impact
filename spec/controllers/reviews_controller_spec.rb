require 'spec_helper'

describe ReviewsController do
	#Initialization stuff
  stub_abilities
  set_referer

  subject { response }

  # describe "GET show :" do
  # 	let(:artist) { FactoryGirl.create(:artist) }
  # 	describe "(unauthorized)" do
		# 	before { get :show, {id: artist.id} }
		# 	its_access_is "unauthorized"
  # 	end
  # 	describe "(authorized)" do
  # 		before(:each) { @ability.can :show, Artist }
	 #  	before { get :show, {id: artist.id} }
	 #  	it { should render_template("show") }
	 #  	specify { assigns(:artist).should == artist }
	 #  end
	 #  describe "(RecordNotFound exception)" do
  # 		before(:each) { @ability.can :show, Artist }
	 #  	before { get :show, {id: 10000} }
	 #  	it { should redirect_to root_path }
	 #  end
  # end

  describe "GET new :" do
  	describe "(unauthorized)" do
			before { get :new }
			its_access_is "unauthorized"
  	end
  	describe "(authorized)" do
      let(:product) { FactoryGirl.create :album_with_artists }
  		before do
        @ability.can :create, Review
        get :new, product_type: 'Album', product_id: product.id
      end
	  	it { should render_template("new") }
	  	specify { assigns(:review).should be_new_record }
      specify { assigns(:review).product.should == product }
	  end
  end
end