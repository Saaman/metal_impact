class CreateArtistsPracticesJoinTable < ActiveRecord::Migration
  def up
    create_table :artists_practices, :id => false do |t|
    	t.integer :artist_id, :null => false
    	t.integer :practice_id, :null => false
    end
    add_foreign_key :artists_practices, :artists
    add_foreign_key :artists_practices, :practices
    add_index :artists_practices, [:artist_id, :practice_id], :unique => true
  end

  def down
  	remove_index :artists_practices, :column => [:artist_id, :practice_id]
  	remove_foreign_key :artists_practices, :artists
    remove_foreign_key :artists_practices, :practices
  	drop_table :artists_practices
  end
end
