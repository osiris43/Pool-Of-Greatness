class AddPoolToConfidenceEntry < ActiveRecord::Migration
  def self.up
    change_table :confidence_entries do |t|
      t.references :pool
    end
    ConfidenceEntry.update_all ["pool_id = ?", 3]
  end

  def self.down
    remove_column :confidence_entries, :pool_id
  end
end
