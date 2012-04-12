class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :null => false, :default => "basic"
    add_index :users, :role
  end
end
