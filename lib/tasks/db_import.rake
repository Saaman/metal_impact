namespace :db do
  desc "Import data from old Metal Impact"
  task :import, [:file_name] do|t, args|

    args.with_defaults(:file_name => '*')
    
    Dir[File.join([Rails.root, 'db', 'fixtures', "#{args[:file_name]}.rb"])].sort.each do |fixture|
      puts "Import #{fixture}..."
      load fixture
      puts "==============================================================================="
      puts ""
    end

    puts "create root user"
    create_admin
  end
  
  desc "This drops the db, builds the db, and import the data. Takes more time than simple import"
  task :drop_and_import => ['db:drop', 'db:create', 'db:migrate', 'db:import']

end

def create_admin
  admin = User.new(email: "romain.magny@gmail.com",
                   password: "password1",
                   email_confirmation: "romain.magny@gmail.com",
                   pseudo: "Roro",
                   role: :admin)
  admin.skip_confirmation!
  admin.save
end

def bulk_save(models)
  if models.blank?
    puts "no records to create"
    return
  end

  success_instances_count = 0
  models.each do |model|
    begin
      is_saved = model.save
      success_instances_count += 1 if is_saved
    rescue Exception => ex
      puts "an exception occurs : #{ex.message}"
      puts ""
      next
    end
    unless is_saved
      puts "cannot create #{model.class.name.downcase} : #{model.inspect}"
      puts "errors :"
      model.errors.full_messages.each do |msg|
        puts "     - #{msg}"
      end
      puts ""
    end
  end

  #correct sequence number
  if ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'postgresql'
    query = "SELECT setval('#{models.first.class.name.tableize}_id_seq', #{success_instances_count})"
    puts query
    ActiveRecord::Base.connection.execute(query)
  end

  puts "#{success_instances_count} out of #{models.length} #{models.first.class.name.downcase.pluralize} have been created"
end