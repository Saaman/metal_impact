class Users::RegistrationsController < Devise::RegistrationsController
	skip_before_filter :require_no_authentication, :only => [:new, :create]
  respond_to :js, :only => :new

  def new
    authorize! :create, User
    resource = build_resource
    respond_with resource
  end

  def create
    authorize! :create, User
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      render_with_scope :new
    end
  end

  def destroy
    authorize! :destroy, current_user
    super
  end

  def cancel
    authorize! :destroy, current_user
    super
  end
end