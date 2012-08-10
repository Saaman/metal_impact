namespace :db do
  desc "Fill database with initial data"
  task seed: :environment do

    puts "Create users..."
    make_users
    puts "Create artists..."
    make_artists
    puts "Create albums..."
    make_albums
  end
  
  desc "This drops the db, builds the db, and seeds the data."
  task :reseed => [:environment, 'db:reset', 'db:seed']
end

def make_users
  admin = User.new(email: "romain.magny@gmail.com",
                       password: "password1",
                       email_confirmation: "romain.magny@gmail.com",
                       pseudo: "Roro",
                       role: :admin)
  admin.skip_confirmation!
  admin.save!
  50.times do |n|
    email = "example-#{n+1}@railstutorial.org"
    pseudo = "example-#{n+1}"
    password  = "password1"
    user = User.new(email: email, password: password,
      email_confirmation: email, pseudo: pseudo)
    user.skip_confirmation!
    user.save!
  end
end

def make_artists
  prng = Random.new()
  15.times do |n|
    name = Faker::Lorem.words(prng.rand(1..2)).join(" ")
    biography = Faker::Lorem.paragraphs.join(" ")
    countries = Artist::COUNTRIES_CODES.sample(prng.rand(1..6))
    Artist.create(name: name, biography: biography, countries: countries, 
      practices_attributes: [{:kind => :band}])
  end
end
def make_albums
  prng = Random.new()
  artists = Artist.all
  20.times do |n|
    title = Faker::Lorem.words(prng.rand(1..4)).join(" ")
    kind = Album.kinds.key(prng.rand(0..1))
    release_date = Time.now - prng.rand(1..100).days- prng.rand(1..100).minutes
    album = Album.new(title: title, kind: kind, release_date: release_date)
    album.artists = artists.sample(prng.rand(1..3))
    album.save!
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