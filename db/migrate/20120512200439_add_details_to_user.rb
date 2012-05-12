class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :pseudo, :string

    add_column :users, :date_of_birth, :date

    add_column :users, :gender, :string

  end
end
