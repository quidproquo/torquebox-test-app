
FactoryGirl.define do

  factory :account do

  end

  factory :product do
    name { 'test' }
    price { Random.rand(0.0..1.0) }
  end

end
