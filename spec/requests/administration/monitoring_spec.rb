require 'spec_helper'

describe "Debug features" do

  describe "it should hide debug features by default", :js => true do
    before { visit '/' }
    it "should not display the version" do
      page.should_not have_selector 'small', text: "#{ENV["SITE_VERSION"]}"
    end
    it "should not display the miniprofiler zone" do
      page.should_not have_selector 'div.profiler-result'
    end
  end

  describe "when being an admin", :js => true do
    sign_in_with_capybara :admin
    describe "and turning debug mode on, should show debug features" do
      before do
        visit '/dashboard'
        click_button 'Activate debug mode'
      end
    	it "should display the miniprofiler zone" do
        print page.html
    		page.should have_selector 'div.profiler-result'
      end
      it "should display the deactivate debug mode button" do
        page.should have_selector 'button', text: 'Deactivate debug mode'
    	end
    end
  end
end