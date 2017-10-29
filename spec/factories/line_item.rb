FactoryGirl.define do
  factory :line_item do
    association :food
    association :cart
    quantity { Faker::Number.number(1) }
  end
end