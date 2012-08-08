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
    sequence(:name) { generate(:random_string) }
    practices [Practice.new(:kind => :band)]
  end

  factory :album do
  	sequence(:title) { generate(:random_string) }
  	sequence(:release_date) { 1.month.ago.to_date }
    kind :album
  end

  factory :music_label do
    sequence(:name) { generate(:random_string) }
    sequence(:website) { "http://www.#{Faker::Internet.domain_name}" }
    sequence(:distributor) { generate(:random_string) }
  end
end