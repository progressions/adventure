class GameController < ApplicationController
  before_filter :require_current_game, except: :start

  def require_current_game
    unless current_game.present?
      redirect_to new_game_url
    end
  end

  def current_game
    game_id = session[:current_game]
    SavedGame.where(id: game_id).try(:first)
  end

  def current_room
    room_id = session[:current_room] ||= current_game.rooms.first.try(:id)
    current_game.rooms.where(id: room_id).try(:first)
  end

  def set_current_room(room)
    session[:current_room] = room.try(:id)
  end

  def play
    if current_game.started?
      set_current_room(current_game.current_room)
    end
  end

  def start
    @saved_game = SavedGame.find(params[:id])
    unless @saved_game.started?
      @saved_game.start
    end
    session[:current_game] = @saved_game.id
    set_current_room(@saved_game.current_room)

    redirect_to game_play_url
  end

  def look
    if current_room.present?
      render :json => current_room.output
    else
      render :json => {
        message: "Nothing to see here."
      }
    end
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
    when "drop"
      if command["direct_object"]
        noun = command["direct_object"]["noun"]
        static_object = Player.inventory.where(name: noun).first

        if static_object.present?
          static_object.update_attribute(:room_id, current_room.id)

          output = {
            message: "You drop #{static_object.name}."
          }
        else
          output = {
            message: "You don't see that."
          }
        end
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
        look and return
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
