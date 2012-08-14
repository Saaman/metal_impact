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

  factory :artist do
    ignore do
      practice_kind :band
    end
    name { generate(:random_string) }
    practices { [Practice.new(:kind => practice_kind)] }
    countries ["FR"]
  end

  factory :album do
  	title { generate(:random_string) }
  	release_date { 1.month.ago.to_date }
    kind :album
    factory :album_with_artists do
      after(:build) { |album| album.artists = FactoryGirl.create_list(:artist, PRNG.rand(1..2), albums: [album]) }
    end
  end

  factory :music_label do
    name { generate(:random_string) }
    sequence(:website) { "http://www.#{Faker::Internet.domain_name}" }
    distributor { generate(:random_string) }
  end
end