class Users::SessionsController < Devise::SessionsController
  #skip_before_filter :require_no_authentication, :only => [:new, :create]
  #prepend_before_filter :allow_params_authentication!, :only => :create
  respond_to :js, :only => [:new, :create]

  # POST /resource/sign_in
  def create
    build_resource
    logger.info "resource = #{resource.inspect}"
    user = User.find_by_email(params["user"]["email"])
    logger.info "user = #{user.inspect}"
    if user.nil? or not user.valid_password?(params["user"]["password"])
      flash["error"] = t "devise.failure.invalid"
    	clean_up_passwords resource
    	respond_with resource do |format|
        format.js  { render 'new' }
      end
    else
      super
    end
  end
end