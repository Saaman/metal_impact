require 'rspec/expectations'

def sign_in_with_capybara(user)
	visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in_without_capybara(user)
	post sessions_path, {:email => user.email, :password => user.password}
	session['remember_token'] = user.remember_token
end

RSpec::Matchers.define :be_signed_in do
  match do |session|
    !session['remember_token'].nil?
  end
end