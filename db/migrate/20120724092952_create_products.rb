class CreateProducts < ActiveRecord::Migration
  def up
  	#rable
    create_table :products do |t|
      t.string :title, :null => false, limit: 511
      t.string :type, :null => false, limit: 15
      t.date :release_date, :null => false

      t.timestamps
    end

    #cover
    add_attachment :products, :cover

    #indexes
    add_index :products, :title
    add_index :products, :created_at, order: {created_at: :desc}
    add_index :products, :release_date
    add_index :products, :type
  end

  def down
  	#indexes
    remove_index :products, :title
    remove_index :products, :created_at
    remove_index :products, :release_date
    remove_index :products, :type

    #cover
    remove_attachment :products, :cover

    #table
    drop_table :products
  end
end