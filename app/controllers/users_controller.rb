class UsersController < ApplicationController


  def new
  end

  def show
    @user = authorize User.find(params[:id])
  end

  def admin_list
    authorize Wiki # we don't have a particular post to authorize
    # Rest of controller action
  end

end
