FactoryBot.define do
  factory :comment do
    comment { Faker::Lorem.sentence }
    association :article
    association :user
    association :room
  end
end
