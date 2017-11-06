FactoryGirl.define do
  factory :voucher do
    code "GOJEK"
    valid_from "2017-11-06"
    valid_through "2017-11-06"
    amount 10.0
    unit "percent"
    max_amount 10000.0
  end

  factory :invalid_voucher, parent: :voucher do
    code nil
    valid_from nil
    valid_through nil
    amount nil
    unit nil
    max_amount nil
  end
end
