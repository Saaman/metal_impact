class CreatePracticesForArtists < ActiveRecord::Migration
  def up
  	create_table :practices do |t|
      t.references 	:artist, :null => false
      t.integer 		:kind_cd, :null => false

      t.timestamps
    end
    add_index :practices, [:artist_id, :kind_cd] , :unique => true
    add_foreign_key :practices, :artists
  end

  def down
  	remove_foreign_key :practices, :artists
  	remove_index :practices, [:artist_id, :kind_cd]
  	drop_table :practices
  end
end
