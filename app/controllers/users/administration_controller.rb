class Users::AdministrationController < ApplicationController
	load_and_authorize_resource class: "User", collection: [:filter]

  def index
  end

  def filter
  end
end
