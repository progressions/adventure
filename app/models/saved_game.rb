class SavedGame < ActiveRecord::Base
  has_many :rooms
  has_many :exits
  has_many :static_objects

  belongs_to :current_room, class_name: Room, foreign_key: :current_room_id

  validates :name, presence: true
  validates :name, uniqueness: true

  def start
    Rails.logger.info("START A NEW GAME")

    started = true
    room = rooms.create(name: "Room", description: "It's a room.")
    kitchen = rooms.create(name: "Kitchen", description: "It's a kitchen.")
    room.exits.create(direction: "north", destination: kitchen)
    kitchen.exits.create(direction: "south", destination: room)
    current_room = room

    save
  end
end
