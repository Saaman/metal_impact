PRNG ||= Random.new()

FactoryGirl.define do

  sequence(:random_string) { |n| Faker::Lorem.words.join(" ") }

  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:pseudo) { |n| "person_#{n}" }
    password "foobar1"
    email_confirmation { email }

    factory :admin do
      role :admin
    end

    after(:create) { |user, evaluator| user.confirm! }
  end

  #create an artist. This will be a band by default, give a practice_kind to change
  factory :artist do
    ignore do
      practice_kind :band
    end
    creator { User.first || FactoryGirl.create(:user) }
    updater { creator }
    name { generate(:random_string) }
    practices { [Practice.find_by_kind(practice_kind)] }
    countries ["FR"]
    published true
  end


  factory :album do
  	title { generate(:random_string) }
  	release_date { 1.month.ago.to_date }
    creator { User.first || FactoryGirl.create(:user) }
    updater { creator }
    published true
    kind :album
    
    trait :with_cover do
      cover { File.open(File.join([uploaders_fixtures_path, 'test_img.png'])) }
    end
    
    trait :with_artists do
      after(:build) { |album| album.artists = FactoryGirl.create_list(:artist, PRNG.rand(1..2), albums: [album]) }
    end
    
    factory :album_with_artists,            traits: [:with_artists]
    factory :album_with_cover,              traits: [:with_cover]
    factory :album_with_artists_and_cover,  traits: [:with_artists, :with_cover]
  end


  factory :music_label do
    name { generate(:random_string) }
    sequence(:website) { "http://www.#{Faker::Internet.domain_name}" }
    distributor { generate(:random_string) }
  end
end