class CreateImportSourceFiles < ActiveRecord::Migration
  def change
    create_table :import_source_files do |t|
      t.string :name, :null => false
      t.string :source, :null => false
      t.string :sha1_checksum, :null => false

      t.timestamps
    end

    add_index :import_source_files, :created_at, order: {created_at: :asc}
  end
end
