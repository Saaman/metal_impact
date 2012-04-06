module ControllerMacros
  def login_user
    let(:user) {FactoryGirl.create(:user) }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
  def login_admin
    let(:user) {FactoryGirl.create(:admin) }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
	# def sign_in_with_capybara(user)
	# 	visit signin_path
	#   fill_in "Email",    with: user.email
	#   fill_in "Password", with: user.password
	#   click_button "Sign in"
	# end
end