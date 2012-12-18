namespace :db do
  desc "download fixtures files from Google Drive"
  task :dl_fixtures do

    puts "clean existing fixtures..."
    puts ""
    Dir.mkdir(File.join([Rails.root, 'db', 'fixtures'])) unless File.directory? File.join([Rails.root, 'db', 'fixtures'])
    Dir[File.join([Rails.root, 'db', 'fixtures', "*.rb"])].each { |f| File.delete f }

    #open a session at Google
    session = GoogleDrive.login ENV["GD_USER"], ENV["GD_PWD"]

    #Get all files of collection name "Fixtures v{version}" and download them
    collection = session.files :title => "Fixtures v#{ENV["SITE_VERSION"].chomp}", "title-exact" => true, showfolders: true
    if collection.length != 1
      puts "collection 'Fixtures v#{ENV["SITE_VERSION"]}' was not found"
      break
    end

    collection[0].files.each do |file|
      puts "download #{file.title}..."
      file.download_to_file File.join([Rails.root, 'db', 'fixtures', "#{file.title}"])
    end

    puts "#{collection[0].files.size} files downloaded succesfully"
    puts ""
  end

  desc "This drops the db, builds the db, and import the data. Takes more time than simple import"
  task :drop_and_import => ['db:drop', 'db:create', 'db:migrate', 'db:import']

  desc "This drops the db, builds the db, download fixtures from Google Drive and import the data."
  task :download_drop_and_import => ['db:dl_fixtures', 'db:drop_and_import']

end