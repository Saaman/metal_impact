class InsertPracticesData < ActiveRecord::Migration
  def up
  	execute "insert into practices (kind_cd) values (0)"
  	execute "insert into practices (kind_cd) values (1)"
  	execute "insert into practices (kind_cd) values (2)"
  	#Practice.create! :kind => :band
  	#Practice.create! :kind => :writer
  	#Practice.create! :kind => :musician
  end

  def down
  end
end
