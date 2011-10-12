class AddDescriptionToSurvivorSession < ActiveRecord::Migration
  def self.up
    add_column :survivor_sessions, :description, :string
    SurvivorSession.reset_column_information
    Transaction.where(:description => "Survivor Pool fee").all.each do |trans|
      trans.update_attributes!(:description => "Survivor Pool 2011-2012 fee")
    end
  end

  def self.down
    remove_column :survivor_sessions, :description
  end
end
