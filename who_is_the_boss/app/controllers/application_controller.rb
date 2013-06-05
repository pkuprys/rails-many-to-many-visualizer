class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    return @current_user ||= User.find_by_id(session[:user_id])
  end
  
  def signed_in?
    return session[:user_id].present?
  end
   def authorize_user
    if !signed_in?
      redirect_to new_session_url, notice: 'Please sign in.'
    end
  end
  
  helper_method :authorize_user
  helper_method :current_user
  helper_method :signed_in?
end
