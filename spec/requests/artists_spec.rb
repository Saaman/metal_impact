require 'spec_helper'

describe "Artists" do
  describe "GET /artists" do
    it "should list artists" do
      visit '/artists'
      page.should have_selector('h1', :text => 'Listing artistes')
    end
  end

  describe "GET /new in album context", :js => true do
  	sign_in_with_capybara :staff

  	describe "going to album form and click artist creation link" do
	  	before do
	  		visit '/albums/new'
	  		click_link 'create a new artist'
	  	end
	  	it "should display the artist creation popup" do
	  		page.should have_selector 'form#new_artist'
	  	end
	  end
  end
end
