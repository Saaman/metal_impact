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

    if verify_recaptcha(:model => resource, message: t("recaptcha.errors.verification_failed_on_sign_up")) && resource.valid?
      super
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