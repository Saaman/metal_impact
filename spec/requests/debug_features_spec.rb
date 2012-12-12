require 'spec_helper'

describe "Debug features" do
  describe "it should show debug features when user is admin", :js => true do
  	sign_in_with_capybara :admin
  	it "should display the version" do
  		page.should have_selector 'small', text: "#{ENV["SITE_VERSION"]}"
  	end
  end
	describe "it should hide debug features when user is not admin", :js => true do
  	sign_in_with_capybara :staff
  	it "should not display the version" do
  		page.should_not have_selector 'small', text: "#{ENV["SITE_VERSION"]}"
  	end
	end
end