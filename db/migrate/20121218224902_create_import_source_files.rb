class CreateImportSourceFiles < ActiveRecord::Migration
  def change
    create_table :import_source_files do |t|
      t.string :name, :null => false
      t.integer :source_type_cd
      t.string :state, :null => false

      t.timestamps
    end

    add_index :import_source_files, :created_at, order: {created_at: :asc}
    add_index :import_source_files, :state
    add_index :import_source_files, :source_type_cd
  end
end
