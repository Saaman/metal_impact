class UsersController < ApplicationController
	before_filter :signed_in_user,   only: [:destroy, :index, :edit, :update]
	before_filter :correct_user,     only: [:edit, :update]
  before_filter :unsigned_user,    only: [:new, :create]

	def new
		@user = User.new
	end

	def index
    @users = User.paginate(page: params[:page])
  end

	def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
  end

  def update
    if !@user.authenticate(params[:user][:password])
      flash.now[:error] = 'Invalid password'
      render 'edit'
      return
    end
    @user.attributes = params[:user]
    @user.password_confirmation = @user.password
    if @user.save
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if (current_user.admin? && current_user != user) # admins can delete any user except themselves
      destroy_user(user)
      redirect_to users_path
      return
    end
    if (!current_user.admin? && current_user == user) #users can delete themselves
      destroy_user(user)
      redirect_to root_path
      return
    end
    flash[:error] = "You can't delete this user. Operation forbidden"
    redirect_to root_path
  end

	private
    def destroy_user(user)
      user.destroy
      flash[:success] = "User destroyed."
    end

  	def unsigned_user
      redirect_to(root_path) unless !signed_in?
    end

    def correct_user
    	@user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
