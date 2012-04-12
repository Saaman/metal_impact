class CreateMusicLabels < ActiveRecord::Migration
  def change
    create_table :music_labels do |t|
      t.string :name
      t.string :website
      t.string :distributor

      t.timestamps
    end

    add_foreign_key(:albums, :music_labels)
    
  end
end
