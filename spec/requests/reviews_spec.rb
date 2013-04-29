require 'spec_helper'

describe "Reviews" do

  subject { page }

  describe "Login as staff", :js => true do
		let!(:album) { FactoryGirl.create(:album_with_artists, :with_music_genre) }
    sign_in_with_capybara :staff
    describe 'and display album :' do
  		before { visit "/albums/#{album.id}" }

    	it "should display link to 'Add review'" do
    		should have_selector 'form#add_review'
    	end
    	describe "clicking 'Add review' link" do
    		before { click_on 'Add a review' }
    		describe "then 'cancel'" do
    			before { click_on 'Cancel' }
  	  		it "should show 'Add review' link back" do
  	  			should have_selector 'form#add_review'
  	  		end
  	  	end
        it 'should display the review form' do
          should have_selector 'form#new_review'
        end
  	  end
    end
	end
end
