require 'spec_helper'

describe "Artists" do
  describe "GET /artists", :js => true do
    it "should list artists" do      
      visit '/artists'
      page.should have_selector('h1', :text => 'Listing artistes')
    end
  end
end
