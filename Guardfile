# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :gntp, :sticky => false, :host => '127.0.0.1'

#TODO : adapt correctly the watches to match my needs

guard 'rspec', :version => 2, :all_after_pass => false, :cli => '--format doc' do
  
  #lib
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }

  #global
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('config/routes.rb')                           { "spec" }
  watch('app/controllers/application_controller.rb')  { "spec" }

  #self
  watch(%r{^spec/.+_spec\.rb$})
  
  #app
  watch(%r{^app/(.+)\.rb$})                       { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)\.erb$})                      { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})      { |m| "spec/requests/#{m[1]}_pages_spec.rb" }
  watch(%r{^app/helpers/(.+)_helper\.rb$})        { |m| "spec/requests/#{m[1]}_pages_spec.rb" }

  #unused
  #watch(%r{^spec/.+_spec\.rb$})
  #watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
  #["spec/routing/#{m[1]}_routing_spec.rb",
  # "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
  # "spec/acceptance/#{m[1]}_spec.rb",
  # "spec/requests/#{m[1]}_pages_spec.rb"]
  #end
  #watch(%r{^app/views/(.+)/}) { |m| "spec/requests/#{m[1]}_pages_spec.rb" }
end