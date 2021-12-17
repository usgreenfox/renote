FactoryBot.define do
  factory :note do
    title { 'test title' }
    body { Faker::Lorem.characters(number:300) }
    association :user
  end
end