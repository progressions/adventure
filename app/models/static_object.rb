class StaticObject < ActiveRecord::Base
  belongs_to :room

  def self.reset
    StaticObject.all.each do |obj|
      obj.room_id = obj.initial_room_id
      obj.save
    end
  end

  def carried?
    room_id == 0
  end
end
