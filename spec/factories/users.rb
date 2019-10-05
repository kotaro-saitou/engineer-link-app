FactoryBot.define do
  factory :user do
    name "test"
    sequence(:email) { |n| "test#{n}@test.com"}
    password "password"
    
    factory :to_user do
      name "to_user"
      email "touser@email.com"
    end
  end
end
