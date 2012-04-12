class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.date :release_date
      t.string :album_type

      t.timestamps
    end
    add_index :albums, :title, :unique => true
    add_index :albums, :release_date
  end
end
