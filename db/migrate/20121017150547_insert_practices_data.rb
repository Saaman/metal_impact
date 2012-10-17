class InsertPracticesData < ActiveRecord::Migration
  def up
  	Practice.create! :kind => :band
  	Practice.create! :kind => :writer
  	Practice.create! :kind => :musician
  end

  def down
  end
end
