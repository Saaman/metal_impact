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

      sf = Import::SourceFile.new path: source_file

      sf.transaction do
        sf.save!
      end

    end
  end
end