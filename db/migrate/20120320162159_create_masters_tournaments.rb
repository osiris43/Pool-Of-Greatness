class CreateMastersTournaments < ActiveRecord::Migration
  def self.up
    create_table :masters_tournaments do |t|
      t.string :year

      t.timestamps
    end
  end

  def self.down
    drop_table :masters_tournaments
  end
end
