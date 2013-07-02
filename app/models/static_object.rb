class StaticObject < ActiveRecord::Base
  belongs_to :saved_game
  belongs_to :room

  def carried?
    room_id == 0
  end
end
