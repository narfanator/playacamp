class VisitorsController < ApplicationController
  def index
    @users = User.all
    @starting_user = (params[:user].to_i || 1)
  end
end
