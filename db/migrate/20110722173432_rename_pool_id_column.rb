class RenamePoolIdColumn < ActiveRecord::Migration
  def self.up
    change_table :pool_configs do |t|
      t.rename :pool_id_id, :pool_id
    end
  end

  def self.down
  end
end
