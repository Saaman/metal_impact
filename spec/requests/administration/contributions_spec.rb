require 'spec_helper'

describe 'Contributions :', :js => true do
	sign_in_with_capybara :admin

	subject { page }

	let!(:artist) { FactoryGirl.create :artist }
	let!(:contribution) { FactoryGirl.create :contribution, my_object: artist }

	before do
		contribution.save!
		3.times do
			FactoryGirl.create :contribution
		end
		FactoryGirl.create :contribution, my_object: FactoryGirl.create(:album_with_artists)
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
			end
		end
	end
end