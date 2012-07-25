class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name, :null => false, limit: 127

      t.timestamps
    end
    add_index :artists, :name
    add_index :artists, :created_at
  end
end