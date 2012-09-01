# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :position do
    association :account
    association :product

    factory :rich_position do
      quantity { 1000000 }

      factory :rich_cash_position do
        product { Product.cash_product }
      end
    end

  end

end
