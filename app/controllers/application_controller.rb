class ApplicationController < ActionController::Base
	include ApplicationHelper
  include LocaleHelper
  include Exceptions
  
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :alert => exception.message
  end

	rescue_from ActiveRecord::RecordNotFound do |exception|
		logger.info "RecordNotFound exception : #{exception.message}"
    flash[:error] = "invalid record : #{exception.message}"
    redirect_to :back
	end

  rescue_from ActionController::RedirectBackError do |exception|
    logger.info "Cannot find any referer : #{exception.message}"
    redirect_to root_path
  end
end