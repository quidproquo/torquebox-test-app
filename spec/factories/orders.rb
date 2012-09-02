
FactoryGirl.define do

  factory :order do
    # Fields:
    status { Order.statuses.draft }
    side { :buy }
    order_type { :market }
    price { Random.rand(0.1..1.0) }
    original_quantity { 100 }
    pending_quantity { 100 }

    # Associations:
    association :product
    association :account

    # Sub-factories:
    factory :limit_order do
      order_type { Order.order_types.limit }
    end

    factory :market_order do
      order_type { Order.order_types.market }
      price { nil }
    end

    factory :buy_order do
      side { :buy }

      factory :buy_market_order do
        order_type { :market }
        price { nil }

        factory :sent_buy_market_order do
          status { Order.statuses.sent }
          date_sent { Time.now }
          price { Random.rand(0.1..1.0) }

          factory :open_buy_market_order do
            status { Order.statuses.open }

            factory :pending_buy_market_order do
              status { Order.statuses.pending }
            end
          end
        end
      end

      factory :buy_limit_order do
        order_type { :limit }

        factory :sent_buy_limit_order do
          status { Order.statuses.sent }
          date_sent { Time.now }
          price { Random.rand(0.1..1.0) }

          factory :open_buy_limit_order do
            status { Order.statuses.open }

            factory :pending_buy_limit_order do
              status { Order.statuses.pending }
            end
          end
        end
      end

    end # buy_order

    factory :sell_order do
      side { :sell }

      factory :sell_market_order do
        order_type { :market }
        price { nil }

        factory :sent_sell_market_order do
          status { Order.statuses.sent }
          date_sent { Time.now }

          factory :open_sell_market_order do
            status { Order.statuses.open }

            factory :pending_sell_market_order do
              status { Order.statuses.pending }
            end
          end
        end
      end

      factory :sell_limit_order do
        order_type { :limit }

        factory :sent_sell_limit_order do
          status { Order.statuses.sent }
          date_sent { Time.now }

          factory :open_sell_limit_order do
            status { Order.statuses.open }

            factory :pending_sell_limit_order do
              status { Order.statuses.pending }
            end
          end
        end
      end

    end # buy_order

  end # order

end
