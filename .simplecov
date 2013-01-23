SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/app\/assets/'

  add_group "Models" do |src_file|
  	src_file.filename =~ /app\/models/ ||
  	src_file.filename =~ /app\/uploaders/
  end
  add_group "Controllers" do |src_file|
    src_file.filename =~ /app\/presenters/ ||
    src_file.filename =~ /app\/controllers/
  end
  add_group "Views" do |src_file|
    src_file.filename =~ /app\/helpers/ ||
    src_file.filename =~ /app\/inputs/ ||
    src_file.filename =~ /app\/views/
  end
  add_group "Libs" do |src_file|
    src_file.filename =~ /lib\/extras/ ||
    src_file.filename =~ /lib\/modules/ ||
    src_file.filename =~ /app\/components/
  end
end