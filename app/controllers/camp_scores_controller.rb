class CampScoresController < ApplicationController
  before_action :set_camp_score, only: [:show, :edit, :update, :destroy]

  # GET /camp_scores
  # GET /camp_scores.json
  def index
    @camp_scores = CampScore.all
  end

  # GET /camp_scores/1
  # GET /camp_scores/1.json
  def show
  end

  # GET /camp_scores/new
  def new
    @camp_score = CampScore.new
  end

  # GET /camp_scores/1/edit
  def edit
  end

  # POST /camp_scores
  # POST /camp_scores.json
  def create
    @camp_score = CampScore.new(camp_score_params)

    respond_to do |format|
      if @camp_score.save
        format.html { redirect_to @camp_score, notice: 'Camp score was successfully created.' }
        format.json { render :show, status: :created, location: @camp_score }
      else
        format.html { render :new }
        format.json { render json: @camp_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /camp_scores/1
  # PATCH/PUT /camp_scores/1.json
  def update
    respond_to do |format|
      if @camp_score.update(camp_score_params)
        format.html { redirect_to @camp_score, notice: 'Camp score was successfully updated.' }
        format.json { render :show, status: :ok, location: @camp_score }
      else
        format.html { render :edit }
        format.json { render json: @camp_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /camp_scores/1
  # DELETE /camp_scores/1.json
  def destroy
    @camp_score.destroy
    respond_to do |format|
      format.html { redirect_to camp_scores_url, notice: 'Camp score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp_score
      @camp_score = CampScore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def camp_score_params
      params.require(:camp_score).permit(:preparation, :build, :participation, :contribution, :teardown)
    end
end
