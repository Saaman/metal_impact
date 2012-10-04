class CreateAlbums < ActiveRecord::Migration
  def up
  	#table
    create_table :albums do |t|
      #product basic informations
      t.string :title, :null => false, limit: 511
      t.date :release_date, :null => false
      t.string :cover

      #album specific informations
      t.integer :kind_cd, :null => false

      #has_contributions data
      t.boolean :published, :null => false, default: false

      t.userstamps
      t.timestamps
    end

    #music labels
    add_column :albums, :music_label_id, :integer
    add_foreign_key :albums, :music_labels

    #indexes
    add_index :albums, :title
    add_index :albums, :created_at, order: {created_at: :desc}
    add_index :albums, :release_date
    add_index :albums, :kind_cd

    add_index :albums, :creator_id
    add_index :albums, :updater_id
  end

  def down
  	#indexes
    remove_index :albums, :title
    remove_index :albums, :created_at
    remove_index :albums, :release_date
    remove_index :albums, :kind_cd

    remove_index :albums, :creator_id
    remove_index :albums, :updater_id

    #cover
    remove_attachment :albums, :cover

    #music labels
    remove_foreign_key :albums, :music_labels
    remove_column :albums, :music_label_id

    #table
    drop_table :albums
  end
end