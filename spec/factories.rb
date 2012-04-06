FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"

    factory :admin do
      role "admin"
    end

    after_create { |user, evaluator| user.confirm! }
  end
end