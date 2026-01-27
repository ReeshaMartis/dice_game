class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :game_id
      t.string :p1_name
      t.string :p2_name
      t.string :winner
      t.integer :rounds_played
      t.text :rounds_info

      t.timestamps
    end
  end
end
