class ApplicationController < ActionController::Base
  inherit_resources
  include InheritedResources::DSL
  protect_from_forgery

  before_filter :verify_logged_in

  def current_user
    @current_user ||= (session[:user_id].present? && User.find_by_id(session[:user_id]))
  end
  helper_method :current_user

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def verify_logged_in
    unless logged_in?
      cookies[:where_was_i] = request.url unless request.url =~ /log(out|in)/
      redirect_to '/login'
    end
  end

  def toggle_notifications
    current_user.toggle_notifications!
    redirect_to request.referer
  end
end
