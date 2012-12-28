class CreateImportEntries < ActiveRecord::Migration
  def up
    create_table :import_entries do |t|
      t.integer :target_model_cd
      t.integer :source_id
      t.integer :target_id
      t.references :import_source_file
      t.text :data, :null => false
      t.string :state, :null => false, default: 'new'
      t.string :type

      t.timestamps
    end

    add_index :import_entries, :import_source_file_id
    add_index :import_entries, [:source_id, :target_model_cd]
    add_index :import_entries, [:target_id, :target_model_cd]
    add_index :import_entries, :state
    add_index :import_entries, :created_at, order: {created_at: :asc}

    add_foreign_key :import_entries, :import_source_files
  end

  def down
    remove_index :import_entries, :import_source_file_id
    remove_index :import_entries, [:source_id, :target_model_cd]
    remove_index :import_entries, [:target_id, :target_model_cd]
    remove_index :import_entries, :state
    remove_index :import_entries, :created_at
    remove_foreign_key :import_entries, :import_source_files
    drop_table :import_entries
  end

end
