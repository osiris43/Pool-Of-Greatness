class CreateOscarAwards < ActiveRecord::Migration
  def self.up
    create_table :oscar_awards do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :oscar_awards
  end
end
