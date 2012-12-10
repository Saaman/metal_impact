require 'spec_helper'

describe "Devise::Sessions" do
  describe "Login", :js => true do
  	let(:user) { FactoryGirl.create(:user, password: 'password1') }
  	before do
  		visit '/'
      click_link "Login"
  	end
  	it "should display the login modal" do
  		page.should have_selector('form#new_user')
  	end
  	it "should warn on incorrect login infos" do
  		within('form#new_user') do
  			fill_in "user_email", with: "romain.magny"
  			fill_in "user_password", with: "romain"
  			click_button "Connection"
  		end
  		page.should have_selector "div.alert-error", text: "Invalid email or password"
  	end
  	it "should warn on incorrect password" do
  		within('form#new_user') do
  			fill_in "user_email", with: user.email
  			fill_in "user_password", with: "romain"
  			click_button "Connection"
  		end
  		page.should have_selector "div.alert-error", text: "Invalid email or password"
  	end
  	it "should login on correct credentials input, even with uppercased email" do
  		within('form#new_user') do
  			fill_in "user_email", with: user.email.upcase
  			fill_in "user_password", with: 'password1'
  			click_button "Connection"
  		end
  		page.should have_selector "div.alert-info", text: "Signed in successfully"
  		page.should_not have_selector "form#new_user"
  	end
  	it "should_not login on correct credentials input with uppercased password" do
  		within('form#new_user') do
  			fill_in "user_email", with: user.email
  			fill_in "user_password", with: 'PASSWORD1'
  			click_button "Connection"
  		end
  		page.should have_selector "div.alert-error", text: "Invalid email or password"
  	end
  end
end