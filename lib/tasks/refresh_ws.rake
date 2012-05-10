namespace :refresh_ws do
	
	desc "Clean existing GemFile and GuardFile"
	task :cleanup do
		puts "cleanup existing OS dependent files..."
		File.delete(Rails.root.join('Gemfile')) if File.exists? Rails.root.join('Gemfile')
		File.delete(Rails.root.join('GuardFile')) if File.exists? Rails.root.join('GuardFile')
		File.delete(Rails.root.join('spec/spec_helper.rb')) if File.exists? Rails.root.join('spec/spec_helper.rb')
		File.delete(Rails.root.join('.rspec')) if File.exists? Rails.root.join('.rspec')
	end

	desc "Set up base files for Linux"
	task :linux => [:cleanup] do
		puts "setting Gemfile and GuardFile for Linux..."
		FileUtils.copy(Rails.root.join('Gemfile - Linux'), Rails.root.join('Gemfile'))
		FileUtils.copy(Rails.root.join('GuardFile - Linux'), Rails.root.join('GuardFile'))
		FileUtils.copy(Rails.root.join('spec/spec_helper - Linux.rb'), Rails.root.join('spec/spec_helper.rb'))
		FileUtils.copy(Rails.root.join('.rspec - Linux'), Rails.root.join('.rspec'))
	end

	desc "Set up base files for Windows"
	task :windows => [:cleanup] do
		puts "setting Gemfile and GuardFile for Windows..."
		FileUtils.copy(Rails.root.join('Gemfile - Windows'), Rails.root.join('Gemfile'))
		FileUtils.copy(Rails.root.join('GuardFile - Windows'), Rails.root.join('GuardFile'))
		FileUtils.copy(Rails.root.join('spec/spec_helper - Windows.rb'), Rails.root.join('spec/spec_helper.rb'))
		FileUtils.copy(Rails.root.join('.rspec - Windows'), Rails.root.join('.rspec'))
	end
end