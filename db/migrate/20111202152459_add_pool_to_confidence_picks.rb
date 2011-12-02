class AddPoolToConfidencePicks < ActiveRecord::Migration
  def self.up
    add_column :confidence_picks, :pool_id, :integer
  end

  def self.down
    remove_column :confidence_picks, :pool_id
  end
end
