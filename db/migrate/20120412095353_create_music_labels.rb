class CreateMusicLabels < ActiveRecord::Migration
  def up
    create_table :music_labels do |t|
      t.string :name
      t.string :website
      t.string :distributor

      t.timestamps
    end

    add_column :albums, :music_label_id, :integer
    add_foreign_key :albums, :music_labels
    add_index :music_labels, :name, :unique => true
  end

  def down
    remove_index :music_labels, :name
    remove_foreign_key :albums, :music_labels
    remove_column :albums, :music_label_id

    drop_table :music_labels
  end
end
