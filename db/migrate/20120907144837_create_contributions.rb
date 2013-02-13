class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.string :approvable_type,  :null => false
      t.integer :approvable_id,   :null => false
      t.integer :event_cd,        :null => false
      t.string :state,            :null => false
			t.text :draft_object,       :null => false
      t.datetime :original_date,  :null => false
      t.text :reason

      t.timestamps
      t.userstamps
    end

    add_index :contributions, :state
    add_index :contributions, :created_at
    add_index :contributions, [:approvable_type, :approvable_id]

    #userstamps
    add_foreign_key :contributions, :users, column: 'creator_id'
    add_foreign_key :contributions, :users, column: 'updater_id'
    add_index :contributions, :creator_id
    add_index :contributions, :updater_id
  end
end