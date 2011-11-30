class CreateConfidencePicks < ActiveRecord::Migration
  def self.up
    create_table :confidence_picks do |t|
      t.references :bowl
      t.references :user
      t.references :team
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :confidence_picks
  end
end
