class RenamePoolOnPickeWeeks < ActiveRecord::Migration
  def self.up
    change_table :pickem_weeks do |t|
      t.rename :pool_id, :pickem_pool_id
    end
  end

  def self.down
  end
end
