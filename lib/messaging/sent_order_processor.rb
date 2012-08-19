module SentOrderProcessor

  def process_sent_order_ids(product_id, order_ids)
    puts "product_id: #{product_id}, order_ids: #{order_ids}"

    order_book = OrderBook.find_by_product_id(product_id)

    sent_orders = Order.find_all_by_id(order_ids)
    trades = []

    sent_orders.each { |order|
      order.status = 'pending'
      matching_orders = order_book.get_matching_orders(order)

      matching_orders.each { |matching_order|
        break unless order.status == 'pending'
        trades += Trade.create_trades(order, matching_order)

        order_book.add_order(order) if order.status == 'pending'
        order_book.remove_order(matching_order) unless matching_order.status == 'pending'
      }
    }

    true
  end

end
