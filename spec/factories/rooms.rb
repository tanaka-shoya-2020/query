FactoryBot.define do
  factory :room do
    name                    { Faker::Name.name }
    password                { "1a#{Faker::Internet.password(min_length: 4)}" }
    password_confirmation   { password }
  end
end
