class VisitorsController < ApplicationController
  skip_authorization_check

  def index
    @users = User.where(status: :camp).order(:name).all
    @starting_user = (params[:user].to_i || 1)
  end

  def info
    @info_string = File.read "public/_info.html"
  end

  def update_info
    # Update AWS copy
    AWS_BUCKET.files.create(
      key: "_info.html",
      body: params[:info]
    )

    # Update local copy
    File.write "public/_info.html", params[:info]

    #TODO: Notice isn't showing up
    flash[:notice] = "Info successfully updated"
    redirect_to action: :info
  end
end
