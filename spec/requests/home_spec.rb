require 'spec_helper'

describe "Home" do
  describe "GET /" do
    it "should display home page" do      
      visit '/'
      page.should have_selector('h1', :text => 'Home page')
    end
  end

  describe "GET /show_image", :js => true do
  	let(:album) { FactoryGirl.create(:album_with_artists_and_cover) }
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  		sign_in_with_capybara(user)
      visit album_path(album)
  	end

    it "should display home page" do
      page.should have_selector('h1', :text => 'Home page')
    end
  end
end
