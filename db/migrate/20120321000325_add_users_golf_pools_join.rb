class AddUsersGolfPoolsJoin < ActiveRecord::Migration
  def self.up
    create_table :golf_wager_pools_users, :id => false do |t|
      t.references :golf_wager_pool, :user
    end

    add_index :golf_wager_pools_users, [:golf_wager_pool_id, :user_id]
  end

  def self.down
  end
end
