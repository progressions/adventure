class Player
  def self.inventory
    StaticObject.where(room_id: 0)
  end

  def self.inventory_list
    inventory.map(&:name)
  end
end
