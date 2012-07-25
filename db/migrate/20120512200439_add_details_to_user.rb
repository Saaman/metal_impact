class AddDetailsToUser < ActiveRecord::Migration
  def change
  	 change_table :users do |t|
      t.string :pseudo, :null => false, default: "", limit: 127
      t.date :date_of_birth
      t.integer :gender_cd
    end
    
  end
end
