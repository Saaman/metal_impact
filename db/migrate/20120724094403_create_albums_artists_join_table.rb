class CreateAlbumsArtistsJoinTable < ActiveRecord::Migration
  def up
    create_table :albums_artists, :id => false do |t|
      t.integer :album_id, :null => false
    	t.integer :artist_id, :null => false
    end
    add_foreign_key :albums_artists, :albums
    add_foreign_key :albums_artists, :artists
    add_index :albums_artists, [:album_id, :artist_id], :unique => true
  end

  def down
    remove_index :albums_artists, :column => [:album_id, :artist_id]
  	remove_foreign_key :albums_artists, :artists
    remove_foreign_key :albums_artists, :albums
  	drop_table :albums_artists
  end
end
