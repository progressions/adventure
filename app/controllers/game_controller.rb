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

  def start
    session[:current_room] = Room.first.try(:id)
    redirect_to game_url
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
    command = replace_aliases(command)

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
    elsif command["verb"] == "look"
      show and return
    end

    render :json => output
  end

  def replace_aliases(command)
    verb = String(command["verb"]).downcase.strip

    case verb
    when "n", "north"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "north"
      }
    when "s", "south"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "south"
      }
    when "e", "east"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "east"
      }
    when "w", "west"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "west"
      }
    when "l"
      command["verb"] = "look"
    end
    command
  end
end
