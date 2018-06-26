class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!

  helper_method :user_signed_in?
  helper_method :current_user
  helper_method :user_session
end
