#Note : this migration is deprecated. Music labels will be entirely refactored based on target modelling
class CreateMusicLabels < ActiveRecord::Migration
  def up
    create_table :music_labels do |t|
      t.string :name, null: false
      t.string :website, null: false
      t.string :distributor

      t.timestamps
    end

    #add_column :albums, :music_label_id, :integer
    #add_foreign_key :albums, :music_labels
    add_index :music_labels, :name, :unique => true
  end

  def down
    remove_index :music_labels, :name
    #remove_foreign_key :albums, :music_labels
    #remove_column :albums, :music_label_id

    drop_table :music_labels
  end
end
