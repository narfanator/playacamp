class SessionsController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  skip_authorization_check

  def new
    # Just renders the form
  end

  def create
    user = User.find_by_email(login_params[:email].downcase)
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(login_params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      if login_params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to '/'
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to '/login'
  end

  def login_params
    params.permit(:email, :password, :remember_me)
  end
end
