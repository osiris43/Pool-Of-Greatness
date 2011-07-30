class ChangePoolUserColumns < ActiveRecord::Migration
  def self.up
    change_table :poolusers do |t|
      t.rename :pool_id_id, :pool_id
      t.rename :user_id_id, :user_id
    end
  end

  def self.down
  end
end
