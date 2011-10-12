class MigrateCurrentEntriesToSessions < ActiveRecord::Migration
  def self.up
    pool = Pool.find(2)
    session = SurvivorSession.create!(:pool => pool, :starting_week => 1, :ending_week => 5, :season => '2011-2012')
    SurvivorEntry.all.each do |entry|
      entry.update_attributes(:survivor_session => session) 
    end

    change_table :survivor_entries do |t|
      t.remove :pool_id
    end
  end

  def self.down
  end
end
