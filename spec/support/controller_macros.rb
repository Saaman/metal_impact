module ControllerMacros
  def login_user(role = :basic)
    let!(:user) {FactoryGirl.create(:user, role: role) }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end

  def set_referer
    before(:each) do
      request.env["HTTP_REFERER"] = root_path
    end
  end

  def stub_abilities
    before do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability).and_return(@ability)
    end
  end

	def sign_in_with_capybara(role = :basic)
    let!(:user) { FactoryGirl.create(:user, role: role) }
    before do
      visit '/'
      click_link "Login"
      find('form#new_user').fill_in "user_email", with: user.email
      find('form#new_user').fill_in "user_password", with: user.password
      click_button "Connection"
      find('div#notice')
    end
	end
end