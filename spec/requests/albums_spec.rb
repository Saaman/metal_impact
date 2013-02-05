require 'spec_helper'

describe "Albums" do

	subject { page }

	describe "Update album", :js => true do
		let!(:album) { FactoryGirl.create(:album_with_artists) }
		let!(:music_label) { FactoryGirl.create(:music_label) }
  	sign_in_with_capybara :admin #otherwise changes are not published ;-)

  	describe 'with music label' do
  		before do
	  		visit "/albums/#{album.id}/edit"
	  	end
	  	it 'should display the album form with values prefilled' do
	  		should have_selector "form#edit_album_#{album.id}"
	  		should have_selector "input#album_title[value='#{album.title}']"
				should have_selector "input#product_artist_ids_#{album.artists[0].id}"
			end
			describe 'pick a label' do
				before do
					within "form#edit_album_#{album.id}" do
						fill_in 'label_typeahead', with: music_label.name[1..3]
					end
					find('ul.typeahead').find('li:first a').click
				end
				it 'should associate the label choosen' do
					should have_selector 'div#music_label_block', text: music_label.name
					should have_selector "input#album_music_label_id[value='#{music_label.id}']"
				end
				describe 'update the album with label' do
					before do
						click_on 'Update album'
					end
					it 'should display updated infos' do
						should have_selector 'div.alert-info', text: /successfully/
						should have_content music_label.name
					end
				end
			end
		end
  end
end