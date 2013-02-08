require 'spec_helper'

describe 'Contributions :', :js => true do
	sign_in_with_capybara :admin

	subject { page }

	let!(:artist) { FactoryGirl.create :artist }
	let!(:contribution) { Contribution.new object: artist }

	before do
		contribution.save!
		3.times do
			c = Contribution.new object: FactoryGirl.create(:artist)
			c.save!
		end

		c = Contribution.new object: FactoryGirl.create(:album_with_artists)
		c.save!
	end

	describe "Go to list of pending contributions" do
		before { visit '/administration/contributions' }
		it "should display my contribution" do
			should have_selector "tr[data-contribution-id='#{contribution.id}']"
			should have_selector "h4", text: artist.name
		end
	end
end