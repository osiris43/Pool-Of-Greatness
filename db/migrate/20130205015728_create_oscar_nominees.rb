class CreateOscarNominees < ActiveRecord::Migration
  def self.up
    create_table :oscar_nominees do |t|
      t.string :nominee

      t.timestamps
    end
  end

  def self.down
    drop_table :oscar_nominees
  end
end
