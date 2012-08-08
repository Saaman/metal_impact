class CreateAlbumsArtistsJoinTable < ActiveRecord::Migration
  def up
    create_table :albums_artists, :id => false do |t|
    	t.integer :artist_id, :null => false
    	t.integer :album_id, :null => false
    end
    add_foreign_key :albums_artists, :artists
    add_foreign_key :albums_artists, :albums
  end

  def down
  	remove_foreign_key :albums_artists, :artists
    remove_foreign_key :albums_artists, :albums
  	drop_table :albums_artists
  end
end
