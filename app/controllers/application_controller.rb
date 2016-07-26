class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Mobu::DetectMobile

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_user!
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  helper_method :current_user

  def authorize
    logger.info "Looking for user with auth token: #{cookies[:auth_token]}"
    redirect_to new_session_path unless current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    logger.error "Error: #{exception} / user (#{current_user.id}) / #{request.original_url}"
    redirect_to main_app.root_url, :alert => "Sorry, you're not authorized to do that!"
  end

  before_filter :authorize
  check_authorization
end
