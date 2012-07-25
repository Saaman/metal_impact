class CreatePracticesForArtists < ActiveRecord::Migration
  def change
  	create_table :practices do |t|
      t.references 	:artist, :null => false
      t.integer 		:kind_cd, :null => false

      t.timestamps
    end
    add_index :practices, [:artist_id, :kind_cd] , :unique => true
    add_index :practices, :artist_id
  end
end
