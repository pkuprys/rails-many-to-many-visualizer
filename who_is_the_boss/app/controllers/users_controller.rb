class UsersController < ApplicationController
  before_filter :authorize_user, :except => [:create, :new]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.email = params[:email]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to index_url
    else
      render 'new', notice: 'User already exists.'
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    if session[:user_id] != @user.id
      redirect_to users_url, notice: 'You do not have permission to edit that user.' 
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.email = params[:email]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    
    if session[:user_id] == @user.id
      if @user.save
        redirect_to users_url, notice: 'Successfully updated user.'
      else
        redirect_to users_url, notice: 'You do not have permission to edit that user.'
      end
    else
      redirect_to users_url, notice: 'You do not have permission to delete that user.'
    end
    
    if @user.save
      redirect_to users_url, notice: 'Successfully updated user.'
    else
      render 'edit', notice: 'FAIL.'
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    
    if session[:user_id] == @user.id
      @user.destroy
      redirect_to index_url
    else
      redirect_to users_url, notice: 'You do not have permission to delete that user.'
    end
  end
end
