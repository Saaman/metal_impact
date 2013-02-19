require 'spec_helper'

describe 'Contributions :', :js => true do
	sign_in_with_capybara :admin

	subject { page }

	let!(:artist) { FactoryGirl.create :artist, published: false, name: 'toto' }
	let!(:contribution) { FactoryGirl.create :contribution, my_object: artist }

	before do
		contribution.save!
		3.times do
			FactoryGirl.create :contribution
		end
		FactoryGirl.create :contribution, my_object: FactoryGirl.create(:album_with_artists)
	end

	describe "Go to list of pending contributions from dashboard" do
		before { click_link 'Dashboard' }
		it "should display number of contributions" do
			should have_content "#{Contribution.count}"
		end
		describe 'follow link should bring to contributions list' do
			before { click_link 'Validate' }
			it "should display contributions#index" do
				should have_selector 'h1', text: 'Contributions to approve'
			end
		end
	end

	describe "Go to list of pending contributions" do
		before { click_link 'Contributions' }
		it "should display my contribution" do
			should have_selector "tr[data-contribution-id='#{contribution.id}']"
			should have_selector "h4", text: artist.name
		end
		describe 'and pick mine' do
			before { find("tr[data-contribution-id='#{contribution.id}']").click }
			it 'should display the detail of the contribution' do
				should have_content contribution.title
				should have_selector "input[value='Approve']"
				should have_selector "input[value='Refuse']"
			end
			describe 'then approve it' do
				before { click_button 'Approve' }
				it 'should show the artist published' do
					should have_selector 'h1', text: artist.name.upcase
					artist.reload.should be_published
				end
			end
			describe 'then refuse it' do
				before { click_button 'Refuse' }
				it 'should go back to the list of contributions' do
					should have_selector 'h1', text: 'Contributions to approve'
					artist.reload.should_not be_published
				end
			end
		end
	end
end