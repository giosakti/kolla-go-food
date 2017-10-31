FactoryGirl.define do
  factory :category do
    name { Faker::Dessert.variety } 
    # This could be any faker, though
  end

  factory :invalid_category, parent: :category do
    name nil
  end
end