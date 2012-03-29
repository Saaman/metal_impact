class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
  	if ENV['RAILS_ENV'] == 'test'
  		Rails.logger.info "Access denied on #{exception.action} #{exception.subject.inspect}"
  	end
    flash[:error] = exception.message
    redirect_to root_url
  end
  
end
