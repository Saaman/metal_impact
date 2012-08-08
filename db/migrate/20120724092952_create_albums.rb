class CreateAlbums < ActiveRecord::Migration
  def up
  	#table
    create_table :albums do |t|
      #product basic informations
      t.string :title, :null => false, limit: 511
      t.date :release_date, :null => false

      #album specific informations
      t.integer :kind_cd, :null => false

      t.timestamps
    end

    #cover
    add_attachment :albums, :cover

    #indexes
    add_index :albums, :title
    add_index :albums, :created_at, order: {created_at: :desc}
    add_index :albums, :release_date
    add_index :albums, :kind_cd
  end

  def down
  	#indexes
    remove_index :albums, :title
    remove_index :albums, :created_at
    remove_index :albums, :release_date
    remove_index :albums, :kind_cd

    #cover
    remove_attachment :albums, :cover

    #table
    drop_table :albums
  end
end