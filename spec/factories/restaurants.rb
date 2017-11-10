FactoryGirl.define do
  factory :restaurant do
    sequence(:name) { |n| "Restaurant-#{n}" }
    address { Faker::Address.street_address }
  end
end
