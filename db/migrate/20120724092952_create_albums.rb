class CreateAlbums < ActiveRecord::Migration
  def up
  	#table
    create_table :albums do |t|
      #product basic informations
      t.string :title, :null => false, limit: 511
      t.date :release_date, :null => false

      #album specific informations
      t.integer :kind_cd, :null => false

      #has_contributions data
      t.boolean :published, :null => false, default: false

      t.timestamps
    end

    #cover
    add_attachment :albums, :cover

    #music labels
    add_column :albums, :music_label_id, :integer
    add_foreign_key :albums, :music_labels

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

    #music labels
    remove_foreign_key :albums, :music_labels
    remove_column :albums, :music_label_id

    #table
    drop_table :albums
  end
end