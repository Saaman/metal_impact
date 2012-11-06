require 'spec_helper'

describe "Users::Registrations" do
  describe "Registering", :js => true do
  	let(:new_user) { FactoryGirl.build(:user) }
  	before do
  		visit '/'
      click_link "Register"
  	end
  	it "should warn that email is empty" do
  		find('form#new_user').fill_in "user_email", with: ""
  		find('input#user_email_confirmation').trigger 'focus'
  		page.should have_selector "input#user_email + span.help-inline", text: 'Please fill out this field.'
  	end
  	it "should warn that email is not correct" do
  		find('form#new_user').fill_in "user_email", with: "toto"
  		find('input#user_email_confirmation').trigger 'focus'
  		page.should have_selector "input#user_email + span.help-inline", text: 'must be a valid e-mail address.'
  	end
  	it "should warn that email confirmation does not match" do
      find('form#new_user').fill_in "user_email", with: new_user.email
  		find('form#new_user').fill_in "user_email_confirmation", with: "toto@toto.com"
  		find('input#user_password').trigger 'focus'
  		page.should have_selector "input#user_email_confirmation + span.help-inline", text: "E-mail and confirmation don't match."
  	end
  	it "should warn that password is empty" do
  		find('form#new_user').fill_in "user_password", with: ""
  		find('input#user_pseudo').trigger 'focus'
  		page.should have_selector "input#user_password + span.help-inline", text: 'Please fill out this field.'
  	end
  	it "should warn that password does not respect security rules" do
  		find('form#new_user').fill_in "user_password", with: "toto"
  		find('input#user_pseudo').trigger 'focus'
      page.should have_selector "input#user_password + span.help-inline", text: "must contain 7 characters including at least one that is not a letter."
  	end

    context "uniqueness checks" do
      #this way the user is really commited in another transaction. Otherwise, it's in a rollbacked transaction and in a different thread than webkit, so the test fails.
      before(:all) { FactoryGirl.create(:user, pseudo: "toto", email: new_user.email) }
      after(:all) { User.delete_all }
      it "should warn that the user if the nickname is already taken" do
        find('form#new_user').fill_in "user_pseudo", with: "toto"
        find('input#user_gender_male').trigger 'focus'
        User.find_by_pseudo("toto").should_not be_nil
        page.should have_selector "input#user_pseudo + span.help-inline", text: "This nickname is already taken"
      end
      it "should warn that the user if the email is already taken" do
        find('form#new_user').fill_in "user_email", with: new_user.email
        fill_in "user_email_confirmation", with: new_user.email
        fill_in "user_password", with: new_user.password
        fill_in "user_pseudo", with: new_user.pseudo
        click_button "Submit"
        page.should have_selector 'input#user_email + span.help-inline', text: 'this email is already registered'
      end
    end

    it "should be notified about confirmation mail" do
      within('form#new_user') do 
        fill_in "user_email", with: new_user.email
        fill_in "user_email_confirmation", with: new_user.email
        fill_in "user_password", with: new_user.password
        fill_in "user_pseudo", with: new_user.pseudo
        click_button "Submit"
      end
    	page.should have_selector "div.alert-notice", text: "A message with a confirmation link"
    end
  end
end