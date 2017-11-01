FactoryGirl.define do
  factory :user do
    username { Faker::Internet.unique.user_name }
    password "longpassword"
    password_confirmation "longpassword"
  end
end
