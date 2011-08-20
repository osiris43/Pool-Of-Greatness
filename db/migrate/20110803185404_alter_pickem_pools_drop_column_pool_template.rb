class AlterPickemPoolsDropColumnPoolTemplate < ActiveRecord::Migration
  def self.up
    remove_column :pickem_pools, :pool_template_id
  end

  def self.down
  end
end
