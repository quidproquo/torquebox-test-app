# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :trade do
    price { Random.rand(0.1..1.0) }
    quantity { 1000 }
    association :buy_order, factory: :pending_buy_limit_order
    association :sell_order, factory: :pending_sell_limit_order
    buy_account { buy_order.account }
    sell_account { sell_order.account }
    association :product, factory: :product
  end

end
