SimpleCov.start do
  add_filter "/spec/"
  add_filter '/config/'

  add_group "Models" do |src_file|
  	src_file.filename =~ /app\/models/ ||
  	src_file.filename =~ /app\/uploaders/ ||
  	src_file.filename =~ /app\/presenters/
  end
  add_group "Controllers", "app/controllers"
  add_group "Components" do |src_file|
  	src_file.filename =~ /app\/helpers/ || 
  	src_file.filename =~ /app\/inputs/ || 
    src_file.filename =~ /app\/components/
  end
  add_group "Views", "app/views"
  add_group "Lib", "lib"
end