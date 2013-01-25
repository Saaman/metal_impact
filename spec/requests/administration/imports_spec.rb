require 'spec_helper'

require 'rspec/expectations'
RSpec::Matchers.define :show_progress do |preparation, in_progress, success, failed|
  match do |page|
  	page.has_selector?("div.bar-info[style=\"width: #{preparation}%;\"]")
  	page.has_selector?("div.bar-warning[style=\"width: #{in_progress}%;\"]")
  	page.has_selector?("div.bar-success[style=\"width: #{success}%;\"]")
  	page.has_selector?("div.bar-danger[style=\"width: #{failed}%;\"]")
  end
end

describe 'Imports', :js => true do
	sign_in_with_capybara :admin

	subject { page }

	let!(:source_file) { FactoryGirl.create :source_file, path: test_source_file_path }
	let!(:total_entries) do
		#update this considering the number of records in the test file
		5
	end

	before do
		#Copy fixture file in db\source_files
		FileUtils.cp imports_fixture_path, test_source_file_path
		ENV['WORK_AROUND_ASYNC'] = 'yes'
	end
	after do
		FileUtils.rm test_source_file_path
		ENV['WORK_AROUND_ASYNC'] = nil
	end




	describe "Complete import" do
		before { visit '/administration/imports' }
		it "should display a list wih the source file" do
			should have_selector 'td > a', text: source_file.name
		end
		describe 'detailled view' do
			before { click_link(source_file.name) }
			it 'should display the source file with status new' do
				should have_selector 'h2', text: source_file.name
				should have_selector 'span.label', text: 'New'
				should have_selector "form#edit_import_source_file_#{source_file.id}", :visible => true
				should have_selector 'div.alert'
				should_not have_selector 'a#cancel_change_source_type'
			end
			describe 'set source_type' do
				before do
					select('Metal Impact', :from => 'import_source_file[source_type]')
					click_button 'Load file'
				end
				it 'should display source file loaded' do
					should have_selector 'span.label-info', text: 'Loaded'
					should have_selector 'a#change_source_type'
					should have_selector "form#edit_import_source_file_#{source_file.id}"

					should show_progress 10, 0, 0, 0
				end
				describe 'change source_type' do
					before { click_link 'Change source type' }
					it 'should toggle the source_type form' do
						should have_selector 'select#import_source_file_source_type', visible: true
						should have_selector 'a#change_source_type', visible: false
						click_link 'Back'
						should have_selector 'select#import_source_file_source_type', visible: false
						should have_selector 'a#change_source_type', visible: true
					end
				end
				describe 'prepare entries' do
					before { click_button 'Prepare entries' }
					it 'should display source file with status prepared' do
						should have_selector 'span.label-info', text: 'Ready to import'
						should_not have_selector 'a#change_source_type'
						should have_selector "form#edit_import_source_file_#{source_file.id}"

						should show_progress 30, 0, 0, 0
					end
					describe 'import partially' do
						before do
							within "form#edit_import_source_file_#{source_file.id}" do
								fill_in 'import_source_file[import_command][entries_count]', with: 1
								select 'artist', from: 'import_source_file[import_command][entries_type]'
								click_button 'Start'
							end
						end
						it 'should display a partial import' do
							should have_selector 'span.label-info', text: 'Ready to import'
							should_not have_selector 'a#change_source_type'
							should have_selector "form#edit_import_source_file_#{source_file.id}"
							should have_selector 'li', text: '2 entries imported'

							should show_progress 30, 0, 2*70/total_entries, 0
						end
					end
					describe 'import totally' do
						before do
							click_button 'Start'
						end
						it 'should display a complete import' do
							should have_selector 'span.label-success', text: 'Imported'
							should_not have_selector 'a#change_source_type'
							should_not have_selector "form#edit_import_source_file_#{source_file.id}"
							should have_selector 'li', text: "#{total_entries} entries imported"

							should show_progress 0, 0, 100, 0
						end
					end
				end
			end
		end
	end
end