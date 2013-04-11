class ApplicationController < ActionController::Base
	include ApplicationHelper
  include LocaleHelper
  include Exceptions

  #tell public_activity to reference to this controller base to find for activists.
  include PublicActivity::StoreController

  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_filter :set_locale, :authorize_mini_profiler

  #force Rails 3 to reload libs files in Development Mode:
  before_filter :_reload_libs, :if => :_reload_libs?

  around_filter :transactions_filter, :only => [:create, :update, :destroy]


  rescue_from CanCan::AccessDenied do |exception|
    logger.info "access denied : #{exception.message}"

    respond_to do |format|
      flash[:unauthorized] = exception.message
      format.html do
        redirect_to_back
      end
      format.json do
        self.formats = [:json, :html]
        render partial: 'shared/flashes', layout: false, :status => :unauthorized
      end
      format.js do
        self.formats = [:js, :html]
        render partial: 'shared/flashes', layout: false, :status => :unauthorized
      end
    end
  end

	rescue_from ActiveRecord::RecordNotFound do |exception|
		logger.info "RecordNotFound exception : #{exception.message}"
    flash[:error] = "invalid record : #{exception.message}"
    redirect_to_back
	end

  rescue_from ActionController::RedirectBackError do |exception|
    handle_redirect_back_error(exception)
  end

  def authorize_mini_profiler
    if defined? Rack::MiniProfiler
      Rack::MiniProfiler.authorize_request if can_debug?
    end
  end

  protected
    def make_flash_for_contribution contributable, now = false
      raise ArgumentError.new('You must provide a contributable entity to this method') unless contributable.is_a? Contributable
      if now
        flash.now[contributable.flash_key] = contributable.flash_msg
      else
        flash[contributable.flash_key] = contributable.flash_msg
      end
    end

  private
    def transactions_filter
      ActiveRecord::Base.transaction do
        yield
      end
    end

    def redirect_to_back(options={})
       begin
        redirect_to :back, options
      rescue ActionController::RedirectBackError => exception
        handle_redirect_back_error(exception, options)
      end
    end

    def handle_redirect_back_error(exception, options={})
      logger.info "Cannot find any referer : #{exception.message}"
      redirect_to root_path, options
    end


    #############################
    def _reload_libs
      RELOAD_LIBS.each do |lib|
        require_dependency lib
      end
    end

    def _reload_libs?
      defined? RELOAD_LIBS
    end
    #############################
end
