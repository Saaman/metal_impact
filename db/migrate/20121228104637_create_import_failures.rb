class CreateImportFailures < ActiveRecord::Migration
  def up
    create_table :import_failures do |t|
      t.text :description, :null => false
      t.string :code
      t.references :import_entry, :null => false

      t.timestamps
    end

    add_index :import_failures, :import_entry_id
    add_index :import_failures, :created_at, order: {created_at: :asc}

    add_foreign_key :import_failures, :import_entries
  end

  def down
  	remove_index :import_failures, :import_entry_id
    remove_index :import_failures, :created_at
    remove_foreign_key :import_failures, :import_entries

    drop_table :import_failures
  end
end
