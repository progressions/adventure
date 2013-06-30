class GameController < ApplicationController
  def index
  end

  def command
    Rails.logger.info("params: #{params.inspect}")
    command = JSON.parse(params[:command])

    Rails.logger.info("command: #{command.inspect}")

    verb = command["verb"]
    Rails.logger.info("verb: #{verb}")

    render :json => {message: "OK you have done that."}
  end
end
