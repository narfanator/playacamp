require 'csv'

class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy, :send_tickets, :give_tickets]

  # GET /users
  # GET /users.json
  def index
    @users = User.where(search_params[:filter]).order(search_params[:search] || :name).all

    #TODO: This sucks VVV Find a better way
    if params[:sort]

      if params[:sort][:score]
        @users = @users.sort{ |a,b|
          a.score <=> b.score
        }

        @users.reverse! if params[:sort][:score] == 'desc'
      end

      if params[:sort][:work_unit]
        @users = @users.sort{ |a,b|
          a.work_unit <=> b.work_unit
        }
      end

      if params[:sort][:tickets_held]
        @users = @users.sort{ |a,b|
          [(a.tickets.count - a.needed_tickets),0].max <=> [(b.tickets.count - b.needed_tickets),0].max
        }

        @users.reverse! if params[:sort][:tickets_held] == 'desc'
      end
    end

    if params[:select]
      if params[:select][:ticket_motion] == 'Give'
        @users = @users.select{|user| user.needed_tickets > user.tickets.count }
      elsif params[:select][:ticket_motion] == 'Send'
        @users = @users.select{|user| user.tickets.count > user.needed_tickets }
      end

      if params[:select][:ticketed] == 'true'
        @users = @users.select{|user| user.tickets.count >= user.needed_tickets && user.status == "camper" }
      elsif params[:select][:ticketed] == 'false'
        @users = @users.select{|user| !(user.tickets.count >= user.needed_tickets) && user.status == "camper" }
      end
    end


    @tickets = Ticket.where("created_at > '2017-01-01'")
  end

  def send_tickets
    @tickets = @user.tickets
    @users = User.all.select{|u| u.needed_tickets > u.tickets.count}.sort{|a,b| b.score <=> a.score}
  end

  def give_tickets
    in_need = User.all.select{|u| u.needed_tickets > u.tickets.count}.sort{|a,b| b.score <=> a.score}
    holding = User.all.select{|u| u.tickets.count > 0}.sort{|a,b| b.score <=> a.score} - in_need
    @held_tickets = holding.collect{|u| u.tickets[1..-1]}.flatten
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.stuffpics = params[:user][:stuffpics]
    @user.password = @user.password_confirmation = SecureRandom.urlsafe_base64 #TODO: Move to model

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    images = @user.stuffpics
    (params[:stuffpic_deletions]||{}).select{|i,d| d == "1"}.keys.each do |i|
      images.delete_at(i.to_i);
    end
    images += (params[:user][:stuffpics] || [])
    @user.stuffpics = images
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_csv
    flash[:errors] ||= []
    CSV.parse(params['csv'].read, :headers => true) do |row|
      errors = User.upsert_from_csv_entry row
      flash[:errors] << errors if errors.any?
    end

    redirect_to action: :index
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #Handle stuffpics seperately
      params.require(:user).permit(:name, :email, :phone, :userpic, :bikepic, :password, :password_confirmation, :facebook, :status)
    end

    def search_params
      params.permit(
        search: %i(score tickets_held name email),
        filter: %i(ticket_motion ticketed status location)
      )
    end
end
