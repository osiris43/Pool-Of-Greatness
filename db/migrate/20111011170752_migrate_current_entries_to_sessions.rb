class MigrateCurrentEntriesToSessions < ActiveRecord::Migration
  def self.up
    change_table :survivor_entries do |t|
      t.remove :pool_id
    end

    pool = Pool.find_by_id(2)
    if pool.nil?
      return
    end
    session = SurvivorSession.create!(:pool => pool, :starting_week => 1, :ending_week => 5, :season => '2011-2012')
    SurvivorEntry.all.each do |entry|
      entry.update_attributes(:survivor_session => session) 
    end

  end

  def self.down
  end
end
