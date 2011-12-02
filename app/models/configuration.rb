class Configuration < ActiveRecord::Base
  def self.get_value_by_key(key)
    Configuration.find_by_key(key).value
  end
end
