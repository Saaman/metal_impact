class Users::PasswordsController < Devise::PasswordsController

def create
  build_resource

  @email = resource.email
  if verify_recaptcha(:model => resource)
  	unless User.find_by_email(@email).nil?
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

def email_sent
  flash.clear  #prevent devise from displaying the email sending message as flash notice
  @email = params[:email]
end

protected

    def after_sending_reset_password_instructions_path_for(resource_name)
      logger.info("email = #{resource.email}")
    	email_sent_user_password_path(email: @email)
    end
end