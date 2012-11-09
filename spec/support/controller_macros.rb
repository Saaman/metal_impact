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
  
	def sign_in_with_capybara(user)
		visit signin_path
	  find('form#new_user').fill_in "user_email", with: user.email
	  find('form#new_user').fill_in "user_password", with: user.password
	  click_button "Connection"
	end
end