class DbConfig < ActiveRecord::Base
  def self.get_value_by_key(key)
    DbConfig.find_by_key(key).value
  end
end
