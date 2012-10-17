class CreatePracticesForArtists < ActiveRecord::Migration
  def up
  	create_table :practices do |t|
      t.integer 		:kind_cd, :null => false

    end
    add_index :practices, :kind_cd , :unique => true
  end

  def down
  	remove_index :practices, :kind_cd
  	drop_table :practices
  end
end
