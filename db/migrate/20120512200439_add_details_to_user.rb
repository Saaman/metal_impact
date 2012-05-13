class AddDetailsToUser < ActiveRecord::Migration
  def change
  	 change_table :users do |t|
      t.string :pseudo, :null => false, default: ""
      t.date :date_of_birth
      t.integer :gender_cd
    end
    
  end
end
