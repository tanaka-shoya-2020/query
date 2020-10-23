FactoryBot.define do
  factory :article do
    title        {Faker::Lorem.sentence(word_count: 3, supplemental: true)}
    text         {Faker::Lorem.paragraphs}
    association :user
    association :room
  end
end
