
FactoryGirl.define do

  factory :account do
    
  end

  factory :product do
    name { 'test' }
    price { Random.rand(0.0..1.0) }
  end

  factory :order do
    # Fields:
    status { 'draft' }
    side { 'buy' }
    type { 'market' }
    price { Random.rand(0.1..1.0) }
    original_quantity { 100 }
    pending_quantity { 100 }

    # Associations:
    product { create(:product) }
    account { create(:account) }
  end

  factory :buy_market_order, class: Order do
    # Fields:
    status { 'draft' }
    side { 'buy' }
    type { 'market' }
    price { Random.rand(0.1..1.0) }
    original_quantity { 100 }
    pending_quantity { 100 }

    # Associations:
    product { create(:product) }
    account { create(:account) }
  end
  
  factory :buy_limit_order, class: Order do
    # Fields:
    status { 'draft' }
    side { 'buy' }
    type { 'limit' }
    price { Random.rand(0.1..1.0) }
    original_quantity { 100 }
    pending_quantity { 100 }

    # Associations:
    product { create(:product) }
    account { create(:account) }
  end
  
  factory :sell_limit_order, class: Order do
    # Fields:
    status { 'draft' }
    side { 'sell' }
    type { 'limit' }
    price { Random.rand(0.1..1.0) }
    original_quantity { 100 }
    pending_quantity { 100 }

    # Associations:
    product { create(:product) }
    account { create(:account) }
  end

end
