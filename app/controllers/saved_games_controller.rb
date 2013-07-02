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
    @saved_game = SavedGame.new(saved_game_params[:saved_game])
    if @saved_game.save
      flash[:notice] = "Your game was saved."
    else
      flash[:error] = "Your game could not be saved."
    end
    session[:current_game] = @saved_game.id

    redirect_to saved_games_url
  end

  private

  def saved_game_params
    params.permit(:name)
  end
end
