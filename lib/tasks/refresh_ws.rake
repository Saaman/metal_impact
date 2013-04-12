namespace :refresh_ws do

	desc "Clean existing OS dependent files"
	task :cleanup do
		puts "cleanup existing OS dependent files..."
		File.delete(Rails.root.join('Gemfile')) if File.exists? Rails.root.join('Gemfile')
		File.delete(Rails.root.join('config/database.yml')) if File.exists? Rails.root.join('config/database.yml')
	end

	desc "Set up OS dependent files for Linux"
	task :linux => [:cleanup] do
		puts "Set up OS dependent files for Linux..."
		FileUtils.copy(Rails.root.join('Gemfile - Linux'), Rails.root.join('Gemfile'))
		FileUtils.copy(Rails.root.join('config/database.yml - Linux'), Rails.root.join('config/database.yml'))
	end

	desc "Set up OS dependent files for Windows"
	task :windows => [:cleanup] do
		puts "Set up OS dependent files for Windows..."
		FileUtils.copy(Rails.root.join('Gemfile - Windows'), Rails.root.join('Gemfile'))
		FileUtils.copy(Rails.root.join('config/database.yml - Windows'), Rails.root.join('config/database.yml'))
	end
end
