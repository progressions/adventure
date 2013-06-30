class GameController < ApplicationController
  def current_room
    room_id = session[:current_room] ||= Room.first.try(:id)
    Room.find(room_id)
  end

  def set_current_room(room)
    session[:current_room] = room.try(:id)
  end

  def index
  end

  def show
    output = {
      description: current_room.description,
      name: current_room.name,
      exits: current_room.exit_list
    }

    render :json => output
  end

  def command
    output = {}

    command = JSON.parse(params[:command])

    verb = command["verb"]

    if command["verb"] == "go"
      dir = command["direct_object"]["noun"]
      destination = current_room.go(dir)
      if destination.present?
        set_current_room(destination)

        output = {
          description: current_room.description,
          name: current_room.name,
          exits: current_room.exit_list
        }
      else
        output = {
          message: "You cannot go that way"
        }
      end
    end

    render :json => output
  end
end
