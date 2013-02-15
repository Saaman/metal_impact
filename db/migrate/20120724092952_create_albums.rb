class CreateAlbums < ActiveRecord::Migration
  def change
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
    add_index :albums, :music_label_id
  end
end