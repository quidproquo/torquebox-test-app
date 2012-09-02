# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :position do
    quantity { Random.rand(100..1000) }
    association :account
    association :product

    factory :poor_position do
      quantity { 0 }

      factory :poor_cash_position do
        product { Product.cash_product }
      end
    end

    factory :rich_position do
      quantity { 1000000 }

      factory :rich_cash_position do
        product { Product.cash_product }
      end
    end

  end

end
