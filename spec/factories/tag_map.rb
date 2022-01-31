FactoryBot.define do
  factory :tag_map do
    association :tag
    association :note
  end
end
