class Users::SessionsController < Devise::SessionsController
  #skip_before_filter :require_no_authentication, :only => [:new, :create]
  #prepend_before_filter :allow_params_authentication!, :only => :create
  respond_to :js, only: [:new, :create]
  respond_to :html, except: [:new, :create]

  # GET /login
  def new
    super
  end

  # POST /login
  def create
    #TODO : revoir ici. C'est pas terrible comme façon de faire, voir comment s'intercaler à l'intérieur du "super". Sans doute en overridant le after_path
    build_resource
    user = User.find_by_email(params["user"]["email"])
    logger.info "resource : #{resource.inspect}"
    logger.info "resource.valid_password?(params['user']['password'] = #{resource.valid_password?(params["user"]["password"])}"
    if user.nil? or not user.valid_password?(params["user"]["password"])
      flash[:error] = t "devise.failure.invalid"
    	clean_up_passwords resource
    	respond_with resource do |format|
        format.js  { render 'new' }
        format.html  { render 'new' }
      end
    else
      super
    end
  end
end