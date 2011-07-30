class ChangeUserIdToAdminIdOnUsers < ActiveRecord::Migration
  def self.up
    change_table :pools do |t|
      t.rename :user_id, :admin_id
    end
  end

  def self.down
    t.rename :admin_id, :user_id
  end
end
