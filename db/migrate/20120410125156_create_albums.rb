class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.date :release_date
      t.string :album_type

      t.timestamps
    end
  end
end
