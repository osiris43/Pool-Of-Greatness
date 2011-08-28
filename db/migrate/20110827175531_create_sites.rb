class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.integer :admin_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
