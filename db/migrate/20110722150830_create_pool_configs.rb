class CreatePoolConfigs < ActiveRecord::Migration
  def self.up
    create_table :pool_configs do |t|
      t.references :pool_id
      t.string :config_key
      t.string :config_value

      t.timestamps
    end
  end

  def self.down
    drop_table :pool_configs
  end
end
