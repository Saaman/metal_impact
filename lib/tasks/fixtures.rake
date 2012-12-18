namespace :fixtures do
  desc "download fixtures files from Google Drive"
  task :download => :clean_fixtures do

    fixtures_folder_path = File.join Rails.root, 'db', 'fixtures'
    Dir.mkdir(fixtures_folder_path) unless File.directory? fixtures_folder_path

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
      file.download_to_file File.join(fixtures_folder_path, "#{file.title}")
    end

    puts "#{collection[0].files.size} files downloaded succesfully"
    puts ""
  end

  desc "clean fixtures folder"
  task :clean_fixtures do
    puts "clean existing fixtures..."
    Dir[File.join([Rails.root, 'db', 'fixtures', "*.*"])].each { |f| File.delete f }
  end

end