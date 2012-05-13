class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_cd, :integer, :null => false, :default => 0
    add_index :users, :role_cd
  end
end