FactoryBot.define do
  factory :user do
    name "test"
    sequence(:email) { |n| "test#{n}@test.com"}
    password "password"
  end
end
