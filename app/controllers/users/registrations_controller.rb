class Users::RegistrationsController < Devise::RegistrationsController
	skip_before_filter :require_no_authentication, :only => [:new, :create]
  before_filter :admins_cant_delete_own_account, :only =>  [:destroy, :cancel]

  private
  	def admins_cant_delete_own_account
  		if current_user.is?("admin")
  			flash[:error] = "administrators are forbidden to delete their own account"
  			redirect_to root_path
  		end
  	end
end