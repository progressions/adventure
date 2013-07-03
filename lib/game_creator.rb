class GameCreator
  attr_accessor :saved_game

  def initialize(saved_game)
    @saved_game = saved_game
  end

  # Create all the objects that make up the game--room, static objects, exits,
  # and associate them with this saved_game record.
  #
  # Set the starting room by setting saved_game.current_room.
  #
  def start
    room = saved_game.rooms.create(name: "Room", description: "It's a room.")
    kitchen = saved_game.rooms.create(name: "Kitchen", description: "It's a kitchen.")

    snuggles = saved_game.static_objects.create(name: "Snuggles", description: "You see Snuggles the fabric softener bear.")
    room.static_objects << snuggles

    room.exits.create(direction: "north", destination: kitchen)
    kitchen.exits.create(direction: "south", destination: room)

    saved_game.current_room = room
  end
end
