class CreatePools1 < ActiveRecord::Migration
  def self.up
    create_table :pools do |t|
      t.references :user
      t.references :pool_template
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
