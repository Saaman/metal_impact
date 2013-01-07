PRNG ||= Random.new()

namespace :db do
  desc "Fill database with initial data"
  task mi_seed: :environment do

    puts "Create users..."
    make_users
    puts "Create bands..."
    make_bands
    puts "Create writers..."
    make_writers
    puts "Create albums..."
    make_albums
  end

  desc "This drops the db, builds the db, and seeds the data. Takes more time than simple reseed"
  task :full_reseed => ['db:drop', 'db:create', 'db:migrate', 'db:seed']

  desc "This reset the db, and seeds the data. Usually don't work as partial seeding will make reseed fails"
  task :reseed => ['db:reset', 'db:seed']
end

def make_users
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

def make_bands
  15.times do |n|
    make_single_artist(:band)
  end
end
def make_writers
  15.times do |n|
    make_single_artist(:writer)
  end
end

def make_albums
  artists = Artist.operates_as(:band)
  20.times do |n|
    title = random_string(1..4)
    kind = Album.kinds.key(PRNG.rand(0..1))
    release_date = Time.now - PRNG.rand(1..100).days- PRNG.rand(1..100).minutes
    album = Album.new(title: title, kind: kind, release_date: release_date)
    album.artists = artists.sample(PRNG.rand(1..3))
    stamp_users album
    if PRNG.rand(0..1) == 0
      album.build_music_label(name: random_string(1..3), distributor: random_string(1..2), website: "http://#{Faker::Internet.domain_name}/#{random_word}")
    else
      album.music_label_id = PRNG.rand(1..MusicLabel.count) if MusicLabel.all.count > 0
    end
    album.save!
  end
end

def make_single_artist(kind)
  name = random_string(1..2)
  biography = Faker::Lorem.paragraphs.join(" ")
  countries = References::COUNTRIES_CODES.sample(PRNG.rand(1..6))
  artist = Artist.new name: name, biography: biography, countries: countries, practices_attributes: [{:kind => kind}]
  stamp_users artist
  artist.save!
end

private
  def random_string(range)
    Faker::Lorem.words(PRNG.rand(range)).join(" ")
  end
  def random_word
    Faker::Lorem.words(1)[0]
  end
  def stamp_users(object)
    object.creator = User.find(PRNG.rand(1..User.count))
    object.updater = User.find(PRNG.rand(1..User.count))
    object
  end