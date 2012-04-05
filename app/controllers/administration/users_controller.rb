class Administration::UsersController < ApplicationController
	load_and_authorize_resource class: "User"

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
  	user = User.find(params[:id])
  	user.update_attributes(role: params[:user][:role])
  end

  def destroy
  	User.find(params[:id]).destroy
  	head :ok
  end
end
