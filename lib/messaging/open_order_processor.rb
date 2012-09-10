module OpenOrderProcessor

  def process_open_order_ids(product_id, order_ids)
    puts "process_open_order_ids(#{product_id}, #{order_ids}).start"

    puts "OrderBook.find_by_product_id(#{product_id}).start"
    order_book = OrderBook.find_by_product_id(product_id)
    puts "OrderBook.find_by_product_id(#{product_id}).end"

    sent_orders = Order.find_all_by_id(order_ids)
    trades = []

    sent_orders.each { |order|
      order.status = Order.statuses.pending
      puts "OrderBook.get_matching_orders(#{order.id}).start"
      matching_orders = order_book.get_matching_orders(order)
      puts "found #{matching_orders.length} matching order(s)"
      puts "OrderBook.get_matching_orders(#{order.id}).end"

      matching_orders.each { |matching_order|
        break unless order.pending?
        trades << Trade.create_trade(order, matching_order)

        order_book.add_order(order) if order.pending?
        order_book.remove_order(matching_order) unless matching_order.pending?
        matching_order.save!
      }
      order.save!
    }

    order_book.save!
    true
  end

end
