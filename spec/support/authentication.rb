require 'rspec/expectations'

def sign_in_with_capybara(user)
	visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end