class AddCurrentRoomToSavedGame < ActiveRecord::Migration
  def change
    add_column :saved_games, :current_room_id, :integer
  end
end
