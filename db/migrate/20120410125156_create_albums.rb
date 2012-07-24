class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.date :release_date, null: false
      t.string :album_type, null: false

      t.timestamps
    end
    add_index :albums, :title, :unique => true
    add_index :albums, :release_date
    add_index :albums, :created_at
  end
end
