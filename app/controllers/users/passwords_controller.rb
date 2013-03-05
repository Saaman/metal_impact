class Users::PasswordsController < Devise::PasswordsController

def create
  build_resource
  @user = resource
	unless User.find_by_email(resource.email).nil?
  	super
    return
  else
  	resource.errors[:base] << I18n.t("devise.passwords.errors.email_taken", :email => params[:user][:email])
  end

  respond_with resource do |format|
    format.html  { render 'new' }
  end
end

def email_sent
  flash.clear  #prevent devise from displaying the email sending message as flash notice
  @user = User.find(params[:id])
end

protected

    def after_sending_reset_password_instructions_path_for(resource_name)
    	email_sent_user_password_path(id: @user)
    end
end