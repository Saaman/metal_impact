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
  	sequence(:title) { Faker::Lorem.words }
  	sequence(:release_date) { DateTime.now }
  	album_type "album"
  end
end