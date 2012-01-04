class AddEntryToConfidencePicks < ActiveRecord::Migration
  def self.up
    change_table :confidence_picks do |t|
      t.references :confidence_entry
    end

    ConfidencePick.reset_column_information

    ConfidencePick.all.each { |f| 
      entry = ConfidenceEntry.where(:user_id => f.user_id).first
      f.update_attributes! :confidence_entry_id => entry.id 
    }
  end

  def self.down
    remove_column :confidence_picks, :confidence_pool
  end
end
