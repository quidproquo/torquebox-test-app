module SentOrderProcessor

  def process_sent_order_ids(product_id, order_ids)
    puts "product_id: #{product_id}, order_ids: #{order_ids}"

    product = Product.find(product_id)
    sent_orders = Order.find_all_by_id(order_ids)
    pending_orders = Order.where(product_id: product_id, status: 'pending')
    trades = []

    sent_orders.each { |sent_order|
      sent_order.status = 'pending'
      pending_orders.each { |pending_order|
        break unless sent_order.status == 'pending'
        if sent_order.price == pending_order.price && sent_order.quantity == pending_order.quantity
          trade = Trade.new(order_id: sent_order.id, price: sent_order.price, quantity: sent_order.quantity)
          trade.save!
          trades << trade
        end
      }
    }

    true
  end

end
