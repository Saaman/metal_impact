require 'spec_helper'

describe "Albums" do

	subject { page }

	describe "Albums index", :js => true do
		let!(:albums) { FactoryGirl.create_list(:album_with_artists, 5) }
		let(:newest_album) { Album.order('created_at DESC').first }
		let(:first_alphabeltical_album) { Album.order('title ASC').first }

		before { visit '/albums' }
		it 'should display list of albums, sorted by creation date desc' do
			should have_selector 'a h4.media-heading:first', text: newest_album.title
			should have_selector 'select#albums_sort_by'
			should have_selector "option[selected='selected']", text: 'Most recent first'
		end
		describe 'changing sort select option' do
			before { select 'Title A -> Z', :from => 'albums_sort_by' }
			it 'should reload page and reorder albums by title' do
				should have_selector 'a h4.media-heading:first', text: first_alphabeltical_album.title
				should have_selector "option[selected='selected']", text: 'Title A -> Z'
			end
		end
	end


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
					it 'should display updated label information' do
						should have_selector 'div.alert-info', text: /successfully/
						should have_content music_label.name
					end
				end
			end
		end
  end

  describe 'Contribute to album :', :js => true do
  	let!(:album) { FactoryGirl.create(:album_with_artists) }
  	sign_in_with_capybara :staff
  	before do
	  	visit "/albums/#{album.id}/edit"
	  end
	  it 'should display the album form with values prefilled' do
  		should have_selector "form#edit_album_#{album.id}"
  		should have_selector "input#album_title[value='#{album.title}']"
			should have_selector "input#product_artist_ids_#{album.artists[0].id}"
		end

		describe 'update title' do
			before do
				within "form#edit_album_#{album.id}" do
					fill_in 'album_title', with: 'ride the lightning'
					click_on 'Update album'
				end
			end
			it 'should create a contribution, and not display updated infos' do
				should have_selector 'div.alert', text: "Contribution on album was submitted for approval."
				should have_selector 'span.album-title', text: /#{album.title}/
			end
		end
	end

	describe 'try change an album with a pending contribution' do
		let!(:album) { FactoryGirl.create(:album_with_artists) }
		let!(:contribution) { FactoryGirl.create :contribution, my_object: album }
  	sign_in_with_capybara :staff
  	before do
	  	visit "/albums/#{album.id}/edit"
	  end
		it 'should display the album form with a warning about a pre-existing contribution' do
  		should have_selector "form#edit_album_#{album.id}"
  		should have_selector 'div.alert', text: /pending change/
		end
  end

end