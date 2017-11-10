FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category-#{n}" }
  end

  factory :invalid_category, parent: :category do
    name nil
  end
end