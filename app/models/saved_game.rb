class SavedGame < ActiveRecord::Base
  has_many :rooms, dependent: :destroy
  has_many :exits, dependent: :destroy
  has_many :static_objects, dependent: :destroy

  belongs_to :current_room, class_name: Room, foreign_key: :current_room_id

  def inventory
    static_objects.where(room_id: 0)
  end

  def inventory_list
    inventory.map(&:name)
  end

  def start
    creator = GameCreator.new(self)
    creator.start

    self.started = true
    save!
  end
end
