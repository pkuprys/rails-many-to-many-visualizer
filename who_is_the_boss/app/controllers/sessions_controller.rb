class SessionsController < ApplicationController
  before_filter :authorize_user, :except => [:create, :new]
  def new
  end

  def create
    u = User.find_by_email(params[:email])
    if u.present? && u.authenticate(params[:password])
      session[:user_id] = u.id
      redirect_to index_url, notice: 'Successfully signed in.'
    else
      redirect_to new_session_url, notice: 'Name or Password unknown.'
    end
  end

  def destroy
    reset_session
    redirect_to new_session_url, notice: 'Sign out successful.'
  end
end
