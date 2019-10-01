FactoryBot.define do
  factory :tag do
    title "test title"
    content "test content"
    association :user
  end
end
