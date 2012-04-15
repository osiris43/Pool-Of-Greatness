class CreateMastersQualifiers < ActiveRecord::Migration
  def self.up
    create_table :masters_qualifiers do |t|
      t.references :pga_player
      t.references :masters_tournament
      t.integer :wager_group

      t.timestamps
    end
  end

  def self.down
    drop_table :masters_qualifiers
  end
end
