class AddPoolToSurvivorEntry < ActiveRecord::Migration
  def self.up
    add_column :survivor_entries, :pool_id, :integer 
    pool = SurvivorPool.where(:name => "POG Survivor").first
    if pool
      SurvivorEntry.reset_column_information
      SurvivorEntry.all.each { |f| f.update_attributes! :pool_id => pool.id }
    end
  end

  def self.down
    remove_column :survivor_entries, :pool_id
  end
end
