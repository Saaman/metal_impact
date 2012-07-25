class CreateArtistsProductsJoinTable < ActiveRecord::Migration
  def up
    create_table :artists_products, :id => false do |t|
    	t.integer :artist_id, :null => false
    	t.integer :product_id, :null => false
    end
    add_foreign_key :artists_products, :artists
    add_foreign_key :artists_products, :products
  end

  def down
  	remove_foreign_key :artists_products, :artists
    remove_foreign_key :artists_products, :products
  	drop_table :artists_products
  end
end
