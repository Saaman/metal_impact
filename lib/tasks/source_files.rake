namespace :source_files do
  desc "download source_file files from Google Drive"
  task :download => :clean do

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
      file.download_to_file File.join(File.join Rails.root, 'db', 'source_files', "#{file.title}")
    end

    puts "#{collection[0].files.size} files downloaded succesfully"
    puts ""
  end

  desc "clean source files folder"
  task :clean => :create_folder do
    puts "clean existing source files..."
    Dir[File.join([Rails.root, 'db', 'source_files', "*.*"])].each { |f| File.delete f }
  end

  desc "create source files folder"
  task :create_folder do
    sources_folder_path = File.join Rails.root, 'db', 'source_files'
    Dir.mkdir(sources_folder_path) unless File.directory? sources_folder_path
  end

end