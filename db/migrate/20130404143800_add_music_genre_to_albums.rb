class AddMusicGenreToAlbums < ActiveRecord::Migration
  def up
  	change_table :albums do |t|
  		t.references :music_genre
		end

		add_foreign_key :albums, :music_genres
		add_index :albums, :music_genre_id
  end

  def down
  	remove_foreign_key :albums, :music_genres
  	remove_index :albums, :music_genre_id

  	change_table :albums do |t|
  		t.remove_references :music_genre
		end
	end
end
