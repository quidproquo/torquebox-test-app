# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :product do

    factory :cash_product do
      name { 'CASH' }
    end

  end

end
