class CreateStaticObjects < ActiveRecord::Migration
  def change
    create_table :static_objects do |t|
      t.string :name
      t.text :description
      t.integer :room_id
      t.integer :saved_game_id

      t.timestamps
    end
  end
end
