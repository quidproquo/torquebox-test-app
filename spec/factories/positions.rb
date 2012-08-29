# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :position do
    association :account
    association :product

    factory :rich_position do
      quantity { 1000000 }

    end

  end

end
