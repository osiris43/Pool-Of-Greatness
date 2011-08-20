class CreatePickemRules < ActiveRecord::Migration
  def self.up
    create_table :pickem_rules do |t|
      t.references :pickem_pool
      t.string :config_key
      t.string :config_value

      t.timestamps
    end
  end

  def self.down
    drop_table :pickem_rules
  end
end
