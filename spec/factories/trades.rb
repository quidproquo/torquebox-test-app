# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trade do
    account_id 1
    order_id 1
    price 1.5
    quantity 1.5
  end
end
