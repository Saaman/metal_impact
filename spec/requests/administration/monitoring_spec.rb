require 'spec_helper'

describe "Debug features" do
  before { Rails.cache.write(:allow_debug, false) } #reset debug mode to false

  describe "it should hide debug features by default", :js => true do
    before { visit '/' }
    it "should not display the debug dump" do
      page.should_not have_selector 'pre.debug_dump'
    end
  end

  describe "when being an admin", :js => true do
    sign_in_with_capybara :admin
    describe "and turning debug mode on, should show debug features" do
      before do
        visit '/dashboard'
        click_button 'Activate debug mode'
      end
    	it "should display the debug dump" do
    		page.should have_selector 'pre.debug_dump'
      end
    end
  end
end