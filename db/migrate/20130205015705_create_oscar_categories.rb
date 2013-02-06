class CreateOscarCategories < ActiveRecord::Migration
  def self.up
    create_table :oscar_categories do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :oscar_categories
  end
end
