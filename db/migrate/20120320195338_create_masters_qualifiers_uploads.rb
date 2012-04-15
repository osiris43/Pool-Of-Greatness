class CreateMastersQualifiersUploads < ActiveRecord::Migration
  def self.up
    change_table :masters_tournaments do |t|
      t.string :importfile_file_name
      t.string :importfile_content_type
      t.string :importfile_file_size
    end
  end

  def self.down
  end
end
