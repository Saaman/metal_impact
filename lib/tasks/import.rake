namespace :import do

	desc "Create test users, one per role"
	# The "=> :environment" is required, as it tails rails to init the complete environment (including loading files!!)
	# If it's not there, it fails on "User" class resolution
  task :test_users => :environment do
  	User.roles.each do |symbol, value|
  		pseudo = "Test_#{symbol.to_s.camelize}"

  		if (existing_user = User.find_by_pseudo pseudo)
  			puts "deleting user #{pseudo}..."
  			existing_user.destroy
  		end

  		user = User.new(	email: "#{symbol}@metal-impact.com",
												email_confirmation: "#{symbol}@metal-impact.com",
												password: "#{symbol}#{value}MI",
												pseudo: pseudo,
												role: symbol)

		  user.skip_confirmation!
		  user.save
  	end

  	puts "#{User.roles.length} test users have been created."

  end

  desc "Import YAML fixtures into import engine"
  task :yaml_files => :environment do

    Dir[File.join([Rails.root, 'db', 'source_files', "*.yml"])].sort.each do |source_file|
      puts "Import #{source_file}..."

      entries_count = 0
      entries = []

      File.open(source_file, 'r') do |io|
        YAML.load_stream(io) do |record|
          entries << Import::Entry.new(data: HashWithIndifferentAccess.new(record))
          entries_count += 1

          if entries_count.modulo(200) == 0
            Import::Entry.import entries
            puts "#{entries_count} entries processed..."
            entries.clear
          end
        end
      end
      Import::Entry.import entries
      puts "Succesfully imported #{entries_count} entries"
      puts "------------------------------------------------------"
    end
  end
end