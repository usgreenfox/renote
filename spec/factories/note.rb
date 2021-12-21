FactoryBot.define do
  factory :note do
    title { Faker::Lorem.characters(number:30) }
    body { Faker::Lorem.characters(number:300) }
    association :user
  end
end