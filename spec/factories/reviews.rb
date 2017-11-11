FactoryGirl.define do
  factory :food_review, class: "Review" do
    reviewer_name { Faker::Name.first_name }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :reviewable, factory: :food
  end

  factory :invalid_food_review, parent: :food_review do
    reviewer_name nil
    title nil
    description nil
    reviewable nil
  end

  factory :restaurant_review, class: "Review" do
    reviewer_name { Faker::Name.first_name }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :reviewable, factory: :restaurant
  end

  factory :invalid_restaurant_review, parent: :restaurant_review do
    reviewer_name nil
    title nil
    description nil
    reviewable nil
  end
end
