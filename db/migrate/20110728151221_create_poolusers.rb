class CreatePoolusers < ActiveRecord::Migration
  def self.up
    create_table :poolusers do |t|
      t.references :pool_id
      t.references :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :poolusers
  end
end
