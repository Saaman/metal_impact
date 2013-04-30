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
        describe 'then submitting the form' do
          before do
            within 'form#new_review' do
              select '3', from: 'review_score'
              fill_in 'review_body', with: 'text chunk'
            end
            click_on 'Create review'
          end
          it 'should display the album with review' do
            should have_content album.music_genre.name
            should have_content album.title
            should have_content "text chunk"
            should_not have_selector 'form#new_review'
            should have_selector 'div#warning.alert'
          end
        end

        describe 'submitting a review twice fails' do
          let!(:previous_review) { FactoryGirl.create :review, product: album, reviewer: user }
          before do
            within 'form#new_review' do
              select '3', from: 'review_score'
              fill_in 'review_body', with: 'text chunk'
            end
            click_on 'Create review'
          end
          it 'should display the album form with errors' do
            should have_selector 'div.alert-error'
            should have_selector 'form#new_review'
            should have_selector "label[for='review_score']"
          end
        end
  	  end
    end
	end
end
