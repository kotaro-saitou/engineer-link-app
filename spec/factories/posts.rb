FactoryBot.define do
  factory :post do
    content 'test content'
    association :user
  end
end
