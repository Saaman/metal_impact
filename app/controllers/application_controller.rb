class ApplicationController < ActionController::Base
	include ApplicationHelper
  include LocaleHelper
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_filter :set_locale
  after_filter :store_back_uri

  rescue_from CanCan::AccessDenied do |exception|
  	logger.info "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_url, :alert => exception.message
  end

	rescue_from ActiveRecord::RecordNotFound do |exception|
		logger.info "RecordNotFound exception : #{exception.message}"
		flash[:error] = "invalid record : #{exception.message}"
    redirect_to get_back_uri
	end
end
