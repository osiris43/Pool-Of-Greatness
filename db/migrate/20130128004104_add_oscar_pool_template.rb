class AddOscarPoolTemplate < ActiveRecord::Migration
  def self.up
    PoolTemplate.create!(:name => "OscarPool", :description => "Oscar pool: Pick all the winners of the Oscars") 
  end

  def self.down
  end
end
