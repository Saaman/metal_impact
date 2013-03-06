class AddCachedVotesOnAlbumsAndArtists < ActiveRecord::Migration
  def up
    add_column :albums, :cached_votes_score, :integer, :default => 0
    add_column :albums, :cached_votes_up, :integer, :default => 0
    add_column :albums, :cached_votes_down, :integer, :default => 0

    add_column :artists, :cached_votes_score, :integer, :default => 0
    add_column :artists, :cached_votes_up, :integer, :default => 0
    add_column :artists, :cached_votes_down, :integer, :default => 0

    add_index  :albums, :cached_votes_score
    add_index  :albums, :cached_votes_up
    add_index  :albums, :cached_votes_down

    add_index  :artists, :cached_votes_score
    add_index  :artists, :cached_votes_up
    add_index  :artists, :cached_votes_down
  end

  def down
  	remove_index :albums, :cached_votes_score
    remove_index :albums, :cached_votes_up
    remove_index :albums, :cached_votes_down

    remove_index :artists, :cached_votes_score
    remove_index :artists, :cached_votes_up
    remove_index :artists, :cached_votes_down

    remove_column :albums, :cached_votes_score
    remove_column :albums, :cached_votes_up
    remove_column :albums, :cached_votes_down

    remove_column :artists, :cached_votes_score
    remove_column :artists, :cached_votes_up
    remove_column :artists, :cached_votes_down
  end
end
