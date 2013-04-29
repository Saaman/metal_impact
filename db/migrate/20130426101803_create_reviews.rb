class CreateReviews < ActiveRecord::Migration
  def up
    create_table :reviews do |t|
    	t.references :product, :polymorphic => true
    	Review.create_translation_table! :body => :text
      t.integer :score
      t.references :reviewer

      #has_contributions data
      t.boolean :published, :null => false, default: false

      t.timestamps
    end

    add_foreign_key :reviews, :users, column: 'reviewer_id'
    add_index :reviews, :reviewer_id
    add_index :reviews, [:product_type, :product_id]
  end

  def down
  	remove_index :reviews, :reviewer_id
  	remove_index :reviews, [:product_type, :product_id]
  	remove_foreign_key :reviews, :users

  	Review.drop_translation_table!
  	drop_table :reviews
  end

end
