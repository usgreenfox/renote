FactoryBot.define do
  factory :note do
    title { Faker::Lorem.characters(number:30) }
    body { Faker::Lorem.characters(number:300) }
    association :user

    after(:create) do |note|
      create_list(:tag, 2, notes: [note])
    end
  end
end