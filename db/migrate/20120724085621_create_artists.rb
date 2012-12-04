class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name, :null => false, limit: 127

      #has_contributions data
      t.boolean :published, :null => false, default: false

      t.timestamps
      t.userstamps
    end
    add_index :artists, :name
    add_index :artists, :created_at

    #userstamps
    add_foreign_key :artists, :users, column: 'creator_id'
    add_foreign_key :artists, :users, column: 'updater_id'
    add_index :artists, :creator_id
    add_index :artists, :updater_id
  end
end