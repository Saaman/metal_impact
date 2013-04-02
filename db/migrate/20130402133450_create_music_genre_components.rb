class CreateMusicGenreComponents < ActiveRecord::Migration
  def change
    create_table :music_genre_components do |t|
      t.string :keyword, null: false
      t.string :type, null: false

      t.timestamps
    end

    add_index(:music_genre_components, [:type, :keyword], unique: true)
    add_index(:music_genre_components, [:type, :id])
  end
end
