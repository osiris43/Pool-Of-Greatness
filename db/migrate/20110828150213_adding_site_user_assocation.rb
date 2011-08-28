class AddingSiteUserAssocation < ActiveRecord::Migration
  def self.up
    create_table :sites_users, :id => false do |t|
      t.references :site, :null => false
      t.references :user, :null => false
    end
  end

  def self.down
    drop_table :sites_users
  end
end
