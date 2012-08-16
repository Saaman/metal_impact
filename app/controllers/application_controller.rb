class ApplicationController < ActionController::Base
	include ApplicationHelper
  include LocaleHelper
  include Exceptions
  
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_filter :set_locale
  after_filter :store_back_uri

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to get_back_uri, :alert => exception.message
  end

	rescue_from ActiveRecord::RecordNotFound do |exception|
		logger.info "RecordNotFound exception : #{exception.message}"
    redirect_to get_back_uri, :error => "invalid record : #{exception.message}"
	end
end
