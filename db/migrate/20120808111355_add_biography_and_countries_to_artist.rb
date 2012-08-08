class AddBiographyAndCountriesToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :countries, :string, limit: 127
  end
end
