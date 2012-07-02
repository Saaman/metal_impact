class Users::PasswordsController < Devise::PasswordsController

def create
	authorize! :create, User
  build_resource

  logger.info "email : #{resource.email}"

  if verify_recaptcha(:model => resource)
  	unless User.find_by_email(params[:user][:email]).nil?
    	super
    	return
    else
    	resource.errors[:base] << I18n.t("devise.passwords.errors.email_taken", :email => params[:user][:email])
    end
  end
  respond_with resource do |format|
    format.html  { render 'new' }
  end
end

protected

    def after_sending_reset_password_instructions_path_for(resource)
    	root_path
    end
end