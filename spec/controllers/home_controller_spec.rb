require 'spec_helper'

describe HomeController do
	stub_abilities
	set_referer

	subject { response }

 	describe "GET index :" do
 		describe "(unauthorized)" do
	 		before { get :index }
	 		its_access_is "unauthorized"
	 	end
	 	describe "(authorized)" do
	 		before do
	 			@ability.can :index, :home
	 			get :index
	 		end
	 		its(:code) { should  == "200" }
	 	end
 	end

 	describe "GET show_image :" do
 		let(:test_url) { "http://www.metal-impact.com/modules/Reviews/images/zapruder_straightfromthehorsesmouth.jpg" }
 		describe "(unauthorized)" do
 			before { get :show_image, {image_link: Rack::Utils.escape(test_url) } }
			its_access_is "unauthorized"
	 	end
	 	describe "(authorized)" do
	 		before(:each) { @ability.can :show_image, :home }
 			before { get :show_image, {image_link: Rack::Utils.escape(test_url) } }
 			it 'should render show_image' do
 				assigns(:image_link).should == test_url
			end
	 	end
 	end
end
