class SavedGamesController < ApplicationController
  def index
    @saved_games = SavedGame.all
  end

  def new
    @saved_game = SavedGame.new
  end

  def edit
    @saved_game = SavedGame.find(params[:id])
  end

  def create
    @saved_game = SavedGame.new(saved_game_params)
    if @saved_game.save
      flash[:notice] = "Your game was saved."
      session[:current_game] = @saved_game.id
      redirect_to saved_games_url
    else
      flash[:error] = "Your game could not be saved."
      render :new
    end

  end

  private

  def saved_game_params
    params.require(:saved_game).permit(:name)
  end
end
