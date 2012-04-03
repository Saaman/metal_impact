class Administration::UsersController < ApplicationController
	load_and_authorize_resource class: "User", collection: [:filter]

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
  	User.find(params[:id]).destroy
  	head :ok
  end
end
