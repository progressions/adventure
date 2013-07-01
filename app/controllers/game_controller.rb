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
    StaticObject.reset
    redirect_to game_url
  end

  def show
    render :json => current_room.output
  end

  def command
    output = {}

    command = JSON.parse(params[:command])
    command = replace_aliases(command)

    verb = command["verb"]

    case command["verb"]
    when "go"
      dir = command["direct_object"]["noun"]
      destination = current_room.go(dir)
      if destination.present?
        set_current_room(destination)

        output = current_room.output
      else
        output = {
          message: "You cannot go that way"
        }
      end
    when "get"
      if command["direct_object"]
        noun = command["direct_object"]["noun"]
        static_object = current_room.static_objects.where(name: noun).first

        if static_object.present?
          static_object.update_attribute(:room_id, 0)

          output = {
            message: "You take #{static_object.name}."
          }
        else
          output = {
            message: "You don't see that."
          }
        end
      end
    when "inventory"
      output = {
        message: "You are carrying the following items: #{Player.inventory_list.join(', ')}."
      }
    when "look"
      if command["direct_object"]
        noun = command["direct_object"]["noun"]
        static_object = current_room.static_objects.where(name: noun).first || Player.inventory.where(name: noun).first

        if static_object.present?
          output = {
            message: static_object.description
          }
        else
          output = {
            message: "You don't see that."
          }
        end
      else
        show and return
      end
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
    when "nw", "northwest"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "northwest"
      }
    when "sw", "southwest"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "southwest"
      }
    when "ne", "northeast"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "northeast"
      }
    when "se", "southeast"
      command["verb"] = "go"
      command["direct_object"] = {
        "noun" => "southeast"
      }
    when "i", "inv"
      command["verb"] = "inventory"
    when "l"
      command["verb"] = "look"
    end
    command
  end
end
