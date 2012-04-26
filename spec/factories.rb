FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"

    factory :admin do
      role "admin"
    end

    after_create { |user, evaluator| user.confirm! }
  end

  factory :album do
  	sequence(:title) { Faker::Lorem.words.join(" ") }
  	sequence(:release_date) { 1.month.ago.to_date }
  	album_type "album"
  end

  factory :music_label do
    sequence(:name) { Faker::Lorem.words.join(" ") }
    sequence(:website) { "http://www.#{Faker::Internet.domain_name}" }
    sequence(:distributor) { Faker::Lorem.words.join(" ") }
  end
end