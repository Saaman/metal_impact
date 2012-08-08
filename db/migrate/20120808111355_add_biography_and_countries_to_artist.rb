class AddBiographyAndCountriesToArtist < ActiveRecord::Migration
  def up
    add_column :artists, :countries, :string, limit: 127
    Artist.create_translation_table! :biography => :text
  end

  def down
  	remove_column :artists, :countries
  	Artist.drop_translation_table!
  end
end
