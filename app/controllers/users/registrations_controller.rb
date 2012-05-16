class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]

  def new
    authorize! :create, User
    resource = build_resource
    respond_with resource
  end

  def create
    authorize! :create, User
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      logger.info "redirect to #{new_user_registration_url}"
      logger.info "request : #{request.format.inspect}"
      respond_with resource do |format|
        format.js do
          render :json => resource.errors, :status => :unprocessable_entity
        end
      end
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