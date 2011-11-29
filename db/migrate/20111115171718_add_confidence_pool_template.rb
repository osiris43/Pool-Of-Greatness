class AddConfidencePoolTemplate < ActiveRecord::Migration
  def self.up
    PoolTemplate.create!(:name => "ConfidencePool", :description => "Confidence Pool: pick and rank teams based on confidence") 
  end

  def self.down
  end
end
