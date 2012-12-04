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
    sign_in_with_capybara

    describe "when displaying an album" do
      before { visit "/albums/#{album.id}" }
      it "should show a clickable image" do
        page.should have_selector 'a[data-target="div#modal-image"] img'
      end
      describe "when clicking the image" do
        before { find('a[data-target="div#modal-image"] img').click }
        it "should display the full-size image in a modal" do
          page.should have_selector 'span.centered-img-helper'
          page.should have_selector 'img.img-rounded'
        end
        it "and close the modal when clicking again" do
          find('img.img-rounded').trigger 'click'
          page.should_not have_selector 'div#modal-image[aria-hidden="false"]'
        end
      end
    end
  end
end
