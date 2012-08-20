class ApplicationController < ActionController::Base
	include ApplicationHelper
  include LocaleHelper
  include Exceptions
  
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to_back :alert => exception.message
  end

	rescue_from ActiveRecord::RecordNotFound do |exception|
		logger.info "RecordNotFound exception : #{exception.message}"
    flash[:error] = "invalid record : #{exception.message}"
    redirect_to_back
	end

  rescue_from ActionController::RedirectBackError do |exception|
    handle_redirect_back_error(exception)
  end

  private
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
end