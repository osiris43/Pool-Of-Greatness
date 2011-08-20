class RemoveColumnsFromTeams < ActiveRecord::Migration
  def self.up
    change_table :teams do |t|
      t.remove :city, :mascot
    end
  end

  def self.down
  end
end
