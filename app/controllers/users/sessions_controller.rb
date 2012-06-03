class Users::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  respond_to :js, :only => [:new, :create]