class InsertPracticesData < ActiveRecord::Migration
  def up
  	execute "insert into practices (kind_cd) values (0)"
  	execute "insert into practices (kind_cd) values (1)"
  	execute "insert into practices (kind_cd) values (2)"
  end

  def down
  	execute "delete from practices"
  end
end
