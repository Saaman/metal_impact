require 'spec_helper'

describe "Albums" do

	subject { page }

	describe "voting features :", :js => true do
		let!(:album) { FactoryGirl.create(:album_with_artists) }
		sign_in_with_capybara :admin #otherwise changes are not published ;-)

  	describe 'go to album detail' do
  		before do
	  		visit "/albums/#{album.id}"
	  	end

	  	it 'should display the voting partial view' do
	  		should_not have_selector 'button.voted'
	  		should have_selector 'button#vote-up span', text: '0'
	  		should have_selector 'button#vote-down span', text: '0'
				should have_selector 'div#votes-display > span', text: '0%'
				album.activities.count.should == 1
	  	end

	  	describe 'and vote up' do
	  		before { click_button 'vote-up' }

	  		it 'should display the vote up' do
	  			should have_selector 'button#vote-up.voted span', text: '1'
	  			should have_selector 'button#vote-down span', text: '0'
					should have_selector 'div#votes-display > span', text: '100%'
					album.activities.count.should == 1
	  		end

	  		describe 'and re-voting up' do
	  			before { click_button 'vote-up' }

		  		it 'should unvote' do
		  			should have_selector 'button#vote-up.voted span', text: '0'
	  				should have_selector 'button#vote-down span', text: '0'
						should have_selector 'div#votes-display > span', text: '0%'
						album.activities.count.should == 1
	  			end
	  		end
	  		describe 'and voting down' do
	  			before { click_button 'vote-down' }

		  		it 'should vote down' do
		  			should have_selector 'button#vote-up span', text: '0'
	  				should have_selector 'button#vote-down.voted span', text: '1'
						should have_selector 'div#votes-display > span', text: '0%'
						album.activities.count.should == 1
	  			end
	  		end
	  	end
	  end
	end
end