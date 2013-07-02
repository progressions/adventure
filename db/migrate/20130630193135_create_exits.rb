class CreateExits < ActiveRecord::Migration
  def change
    create_table :exits do |t|
      t.string :direction
      t.integer :room_id
      t.integer :destination_id
      t.integer :saved_game_id

      t.timestamps
    end
  end
end
