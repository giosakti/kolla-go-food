FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "Tag-#{n}" }
  end

  factory :invalid_tag, parent: :tag do
    name nil
  end
end
