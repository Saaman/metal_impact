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
      let!(:artist) { FactoryGirl.build(:artist) }
	  	before do
	  		visit '/albums/new'
	  		click_link 'create a new artist'
	  	end
	  	it "should display the artist creation popup" do
	  		page.should have_selector 'form#new_artist'
	  	end
      describe "fail to create an artist that is not a band" do
        before do
          within 'form#new_artist' do
            check 'artist_practice_ids_2'
            fill_in 'Name', with: artist.name
            select 'France', from: 'artist_countries'
            click_button 'Create artist'
          end
        end
        it 'should display an error' do
          page.should have_selector 'form#new_artist'
          page.should have_selector 'div.alert-error'
          page.should have_selector "input[name='artist[practice_ids][]'] + span.help-inline", text: /it is not a 'band'/
        end
      end
      describe "fill-in an artist" do
        before do
          within 'form#new_artist' do
            check 'artist_practice_ids_1'
            fill_in 'Name', with: artist.name
            select 'France', from: 'artist_countries'
            click_button 'Create artist'
          end
        end
        it 'should go back to album form' do
          page.should_not have_selector 'form#new_artist'
          page.should have_selector 'div.artist_label h3', text: "#{artist.name.upcase}"
          page.should have_selector 'div.alert-info', text: "Artist was succesfully created."
        end
      end
	  end
  end
end
