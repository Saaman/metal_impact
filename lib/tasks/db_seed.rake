namespace :db do
  desc "Fill database with initial data"
  task seed: :environment do
    make_users
  end
  
  desc "This drops the db, builds the db, and seeds the data."
  task :reseed => [:environment, 'db:reset', 'db:seed']
end

def make_users
  admin = User.new(email:    "romain.magny@gmail.com",
                       password: "password",
                       password_confirmation: "password",
                       role: "admin")
  admin.skip_confirmation!
  admin.save!
  99.times do |n|
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    user = User.new(email: email, password: password,
      password_confirmation: password)
    user.skip_confirmation!
    user.save!
  end
end

#from original post :

# namespace :db do
#   desc "This loads the development data."
#   task :seed => :environment do
#     require 'active_record/fixtures'
#     Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
#       base_name = File.basename(file, '.*')
#       say "Loading #{base_name}..."
#       Fixtures.create_fixtures('db/fixtures', base_name)
#     end
#   end
# end