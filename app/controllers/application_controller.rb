class ApplicationController < ActionController::Base
	include ApplicationHelper
  include LocaleHelper
  include Exceptions
  include Userstamp

  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_filter :set_locale, :authorize_mini_profiler

  #force Rails 3 to reload libs files in Development Mode:
  before_filter :_reload_libs, :if => :_reload_libs?

  around_filter :transactions_filter, :only => [:create, :update, :destroy]


  rescue_from CanCan::AccessDenied do |exception|
    logger.info "access denied : #{exception.message}"
    redirect_to new_session_path("user"), :format => :js, :alert => exception.message
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
    Rack::MiniProfiler.authorize_request if can_debug?
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