#Note : this migration is deprecated. Music labels will be entirely refactored based on target modelling
class CreateMusicLabels < ActiveRecord::Migration
  def change
    create_table :music_labels do |t|
      t.string :name, null: false
      t.string :website
      t.string :distributor

      t.timestamps
      t.userstamps
    end

    add_index :music_labels, :name, :unique => true

    #userstamps
    add_foreign_key :music_labels, :users, column: 'creator_id'
    add_foreign_key :music_labels, :users, column: 'updater_id'
    add_index :music_labels, :creator_id
    add_index :music_labels, :updater_id
  end
end
