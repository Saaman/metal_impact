class CreateMusicGenres < ActiveRecord::Migration
  def up
  	#MusicGenre
    create_table :music_genres do |t|
    	t.string :computed_name
    	MusicGenre.create_translation_table! :name => :string

      t.timestamps
    end
    add_index :music_genres, :computed_name, unique: true

    #Association table
    create_table :music_genre_components_music_genres, :id => false do |t|
      t.integer :music_genre_id, :null => false
    	t.integer :mg_component_id, :null => false
    end
    add_foreign_key :music_genre_components_music_genres, :music_genres
    add_foreign_key :music_genre_components_music_genres, :music_genre_components, column: 'mg_component_id'
    add_index :music_genre_components_music_genres, [:music_genre_id, :mg_component_id], :unique => true, name: 'index_association_on_music_genre_components_music_genres'
  end

  def down
  	#Association table
  	remove_index :music_genre_components_music_genres, name: 'index_association_on_music_genre_components_music_genres'
  	remove_foreign_key :music_genre_components_music_genres, :music_genres
    remove_foreign_key :music_genre_components_music_genres, :music_genre_components
  	drop_table :music_genre_components_music_genres

  	#MusicGenre
  	MusicGenre.drop_translation_table!
  	remove_index :music_genres, :computed_name
  	drop_table :music_genres
  end

end
