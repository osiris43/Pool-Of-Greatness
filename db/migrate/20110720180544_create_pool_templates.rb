class CreatePoolTemplates < ActiveRecord::Migration
  def self.up
    create_table :pool_templates do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :pool_templates
  end
end
