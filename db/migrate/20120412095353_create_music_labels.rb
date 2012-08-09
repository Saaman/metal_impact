#Note : this migration is deprecated. Music labels will be entirely refactored based on target modelling
class CreateMusicLabels < ActiveRecord::Migration
  def up
    create_table :music_labels do |t|
      t.string :name, null: false
      t.string :website, null: false
      t.string :distributor

      t.timestamps
    end

    add_index :music_labels, :name, :unique => true
  end

  def down
    remove_index :music_labels, :name

    drop_table :music_labels
  end
end
