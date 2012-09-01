module SentOrderProcessor

  def process_sent_orders(orders)
    orders.each { |order| process_sent_order(order) }
  end

  def process_sent_order(order)
    order.sent!
    order.save!
  end

end
