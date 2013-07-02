class SavedGame < ActiveRecord::Base
  has_many :rooms
  has_many :exits
  has_many :static_objects

  belongs_to :current_room, class_name: Room, foreign_key: :current_room_id

  validates :name, presence: true
  validates :name, uniqueness: true

  def start
    Rails.logger.info("START A NEW GAME")

    room = rooms.create(name: "Room", description: "It's a room.")
    current_room = room

    save
  end
end
