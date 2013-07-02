class AddStartedToSavedGame < ActiveRecord::Migration
  def change
    add_column :saved_games, :started, :boolean
  end
end
