class AddLowerUsernameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :lowered_username, :string
    
    User.reset_column_information
    User.all.each do |u|
      temp = u.username.downcase
      u.update_attributes!(:lowered_username => temp)
    end
  end

  def self.down
    remove_column :users, :lowered_username
  end
end
