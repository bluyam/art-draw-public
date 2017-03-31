class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
    
  end
  def archive
    # @sgame = 
    
    @test = Game.search(params[:search])
    render games_archive_path
  end

  # GET /games/1
  # GET /games/1.json
  def show
    
  end

  # GET /games/new
  def new
    
    @challenge_name = params[:name]
    @game = Game.new

  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    respond_to do |format|
      if @game.save
        format.html { redirect_to games_url }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
    rescue
      redirect_to '/games/new', :flash => { :error => "Wronge username!" }
  end
   # @game.save

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to games_url }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy

  
    # @game.active = "false"
    respond_to do |format|
      @game.update(:active =>{active: false})
      format.json { head :no_content }
      format.html { redirect_to new_game_path(name: @game.challenge_name) }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # [:clickX, :clickY, :clickDrag, :clickColor]
    def game_params
      # params.require(:game).permit!
      params.require(:game).permit(:challenger_id, :opponent_id, :active, :title, :clickX, :clickY, :clickColor, :clickDrag, :challenge_name)
    end
    
    
end
