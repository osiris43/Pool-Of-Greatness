class CreateOscarNominations < ActiveRecord::Migration
  def self.up
    create_table :oscar_nominations do |t|
      t.references :oscar_award
      t.references :oscar_nominee
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :oscar_nominations
  end
end
