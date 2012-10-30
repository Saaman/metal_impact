require 'spec_helper'

describe "Users::Registrations" do
  describe "Registering", :js => true do
  	let(:new_user) { FactoryGirl.build(:user) }
  	before do
  		visit '/'
      click_link "Register"
      find('form#new_user').fill_in "user_email", with: new_user.email
			find('form#new_user').fill_in "user_email_confirmation", with: new_user.email
			find('form#new_user').fill_in "user_password", with: new_user.password
			find('form#new_user').fill_in "user_pseudo", with: new_user.pseudo
  	end
  	it "should warn that email is empty" do
  		find('form#new_user').fill_in "user_email", with: ""
  		find('form#new_user').click_button "Submit"
  		page.should have_selector "span.help-inline", text: 'Please fill out this field.'
  	end
  	it "should warn that email is not correct" do
  		find('form#new_user').fill_in "user_email", with: "toto"
  		find('form#new_user').click_button "Submit"
      print page.html
  		page.should have_selector "span.help-inline", text: 'must be a valid e-mail address.'
  	end
  	it "should warn that email confirmation does not match" do
  		find('form#new_user').fill_in "user_email_confirmation", with: "toto"
  		find('form#new_user').click_button "Submit"
  		page.should have_selector "span.help-inline", text: "E-mail and confirmation don't match."
  	end
  	it "should warn that password is empty" do
  		find('form#new_user').fill_in "user_password", with: ""
  		find('form#new_user').click_button "Submit"
  		page.should have_selector "span.help-inline", text: 'Please fill out this field.'
  	end
  	it "should warn that password does not respect security rules" do
  		find('form#new_user').fill_in "user_password", with: "toto"
  		find('form#new_user').click_button "Submit"
      print page.html
  		page.should have_selector "span.help-inline", text: "must contain 7 characters including at least one that is not a letter."
  	end


    it "should be notified about confirmation mail" do
    	find('form#new_user').click_button "Submit"
    	page.should have_selector "div.alert-notice", text: "A message with a confirmation link"
    end
  end
end