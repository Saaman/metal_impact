require 'spec_helper'

# RSpec.configure do |c|
#   c.use_transactional_examples = false
#   c.order = "default"
# end

describe "Home", :type => :request do

  describe "GET /" do
    it "should display home page" do      
      visit '/'
      page.should have_selector('h1', :text => 'Home page')
    end
  end

  describe "GET /show_image", :js => true do
  	let(:album) { FactoryGirl.create(:album_with_artists_and_cover) }
    sign_in_with_capybara

    describe "when displaying an album" do
      before { visit "/albums/#{album.id}" }
      it "should show a clickable image" do
        page.should have_selector 'a.modal-trigger img'
      end
    end
  end
end
