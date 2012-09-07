class CreateApprovals < ActiveRecord::Migration
  def self.up
    create_table :approvals do |t|
      t.string  :approvable_type, :null => false
      t.integer :approvable_id,   :null => false
      t.integer  :event_cd,  			:null => false
      t.integer :state_cd,   			:null => false
			t.text    :object,			    :limit => 16777216
      t.text    :original,			  :limit => 16777216
      t.text	  :reason

      t.timestamps
    end

    add_index :approvals, [:state_cd]
    add_index :approvals, [:created_at]
    add_index :approvals, [:approvable_type, :approvable_id]
  end

  def self.down
    remove_index :approvals, [:state_cd]
    remove_index :approvals, [:created_at]
    remove_index :approvals, [:approvable_type, :approvable_id]
		drop_table :approvals
  end
end