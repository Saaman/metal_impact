namespace :refresh_ws do

	desc "Clean existing GemFile and GuardFile"
	task :cleanup do
		puts "cleanup existing OS dependent files..."
		File.delete(Rails.root.join('Gemfile')) if File.exists? Rails.root.join('Gemfile')
		File.delete(Rails.root.join('config/database.yml')) if File.exists? Rails.root.join('config/database.yml')
	end

	desc "Set up base files for Linux"
	task :linux => [:cleanup] do
		puts "setting Gemfile and GuardFile for Linux..."
		FileUtils.copy(Rails.root.join('Gemfile - Linux'), Rails.root.join('Gemfile'))
		FileUtils.copy(Rails.root.join('config/database.yml - Linux'), Rails.root.join('config/database.yml'))
	end

	desc "Set up base files for Windows"
	task :windows => [:cleanup] do
		puts "setting Gemfile and GuardFile for Windows..."
		FileUtils.copy(Rails.root.join('Gemfile - Windows'), Rails.root.join('Gemfile'))
		FileUtils.copy(Rails.root.join('config/database.yml - Windows'), Rails.root.join('config/database.yml'))
	end
end
