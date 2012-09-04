# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_transaction do
    transaction_type_cd ""
    account_id 1
    product_id 1
    quantity 1.5
    cost_basis 1.5
  end
end
