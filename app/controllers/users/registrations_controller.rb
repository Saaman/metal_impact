class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]
  respond_to :json, :only => :is_pseudo_taken

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
      respond_with resource do |format|
        format.js  { render 'new' }
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

  def is_pseudo_taken
    if User.where("pseudo = ?", params[:pseudo]).empty?
      respond_with({ isPseudoTaken: false }, status: :ok )
    else
      respond_with({ isPseudoTaken: true, :errorMessage => t('activerecord.errors.models.user.attributes.pseudo.taken') }, status: :ok)
    end
  end
end