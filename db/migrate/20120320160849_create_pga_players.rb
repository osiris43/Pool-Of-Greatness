class CreatePgaPlayers < ActiveRecord::Migration
  def self.up
    create_table :pga_players do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :pga_players
  end
end
