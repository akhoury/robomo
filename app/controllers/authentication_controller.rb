class AuthenticationController < ApplicationController
  skip_before_filter :verify_logged_in, :only => [:create, :new]

  def new
  end

  def create
    user = User.find_or_create(HashWithIndifferentAccess.new(request.env['omniauth.auth']['user_info']))
    session[:user_id] = user.id
    redirect_to cookies.delete(:where_was_i) || '/'
  end

  def destroy
    session.delete(:user_id)
    redirect_to '/'
  end
end
