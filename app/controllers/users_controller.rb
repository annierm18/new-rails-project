class UsersController < ApplicationController
  before_action :authenticate_user!


  def new
    @user = User.new
  end

  def show
    @user = authorize User.find(params[:id])
    unless current_user.standard?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def standard_list
    authorize Wiki # we don't have a particular post to authorize
    # Rest of controller action
  end

  def edit
   @user = User.find(params[:id])
  end

  def cancel_plan
      @user == current_user
      current_user.update_attributes!(role: 'standard')
      flash[:notice] = "Canceled subscription."
      redirect_to user_path(current_user)
  end


  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      flash[:notice] = "Welcome to Bloccipedia #{@user.name}!"
      create_session(@user)
      redirect_to root_path
    else
      flash.now[:alert] = "There was an error creating your account. Please try again."
      render :new
    end
  end

end
