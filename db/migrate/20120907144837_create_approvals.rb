class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.string :approvable_type, :null => false
      t.integer :approvable_id,   :null => false
      t.integer :event_cd,  			:null => false
      t.integer :state_cd,   			:null => false
			t.text :object
      t.text :original
      t.text :reason

      t.timestamps
      t.userstamps
    end

    add_index :approvals, :state_cd
    add_index :approvals, :created_at
    add_index :approvals, [:approvable_type, :approvable_id]

    #userstamps
    add_foreign_key :approvals, :users, column: 'creator_id'
    add_foreign_key :approvals, :users, column: 'updater_id'
    add_index :approvals, :creator_id
    add_index :approvals, :updater_id
  end
end