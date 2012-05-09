namespace :environment do
	desc "clean production assets from environment"
 	task :clean do
 		puts "cleaning assets..."
 	 	Rake::Task['assets:clean'].invoke
 	 	puts "cleaning tmp..."
 	 	Rake::Task['tmp:clear'].invoke
 end

	desc "Clean and prepare production-like environment"
 	task :prepare  => [:clean] do
 	 	puts "reseed database for environment '#{ENV[RAILS_ENV]}'..."
 	 	Rake::Task['db:reseed'].invoke
    puts "Exporting client-side translations..."
 	 	Rake::Task['i18n:js:export'].invoke
 	 	puts "Precompiling assets..."
 	 	Rake::Task['assets:precompile'].invoke
 	 	puts "Environment ready!"
	end
end