class Users::RegistrationsController < Devise::RegistrationsController
	skip_before_filter :require_no_authentication, :only => [:new, :create]
  before_filter :admins_cant_delete_own_account, :only =>  [:destroy, :cancel]


  def create
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      render_with_scope :new
    end
  end
  
  private
  	def admins_cant_delete_own_account
  		if current_user.is?("admin")
  			flash[:error] = "administrators are forbidden to delete their own account"
  			redirect_to root_path
  		end
  	end
end