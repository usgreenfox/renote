FactoryBot.define do
  factory :remind do
    association :user
    association :note
  end
end
