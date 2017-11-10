FactoryGirl.define do
  factory :review do
    reviewer_name { Faker::Name.first_name }
    title { Faker::Lorem.sentences(1) }
    description { Faker::Lorem.paragraph }
  end

  factory :invalid_review, parent: :review do
    reviewer_name nil
    title nil
    description nil
  end
end
