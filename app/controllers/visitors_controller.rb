class VisitorsController < ApplicationController
  skip_authorization_check
  def index
    @users = User.where(status: :Camp).all
    @starting_user = (params[:user].to_i || 1)
  end
end
