
FactoryGirl.define do

  factory :order do
    # Fields:
    status { :draft }
    side { :buy }
    order_type { :market }
    price { Random.rand(0.1..1.0) }
    original_quantity { 100 }
    pending_quantity { 100 }

    # Associations:
    association :product
    association :account

    # Sub-factories:
    factory :buy_order do
      side { :buy }

      factory :buy_market_order do
        order_type { :market }

        factory :sent_buy_market_order do
          status { :sent }
          date_sent { Date.current }

          factory :pending_buy_market_order do
            status { :pending }
          end
        end
      end

      factory :buy_limit_order do
        order_type { :limit }

        factory :sent_buy_limit_order do
          status { :sent }
          date_sent { Date.current }

          factory :pending_buy_limit_order do
            status { :pending }
          end
        end
      end

    end # buy_order

    factory :sell_order do
      side { :sell }

      factory :sell_market_order do
        order_type { :market }

        factory :sent_sell_market_order do
          status { :sent }
          date_sent { Date.current }

          factory :pending_sell_market_order do
            status { :pending }
          end
        end
      end

      factory :sell_limit_order do
        order_type { :limit }

        factory :sent_sell_limit_order do
          status { :sent }
          date_sent { Date.current }

          factory :pending_sell_limit_order do
            status { :pending }
          end
        end
      end

    end # buy_order

  end # order

end
