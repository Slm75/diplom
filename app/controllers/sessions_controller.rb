class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Логин или пароль введены неверно'
      render 'new'
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end


  def destroy
    sign_out
    redirect_to root_url
  end
end
