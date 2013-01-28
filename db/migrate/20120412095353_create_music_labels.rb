#Note : this migration is deprecated. Music labels will be entirely refactored based on target modelling
class CreateMusicLabels < ActiveRecord::Migration
  def change
    create_table :music_labels do |t|
      t.string :name, null: false
      t.string :website
      t.string :distributor

      t.timestamps
    end

    add_index :music_labels, :name, :unique => true
  end
end
