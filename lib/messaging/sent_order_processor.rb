module SentOrderProcessor

  def process_sent_orders(orders)
    orders.each { |order| process_sent_order(order) }
  end

  def process_sent_order(order)
    order.sent!
    case order.side
    when Order.sides.buy(true)
      process_sent_buy_order(order)
    when Order.sides.sell(true)
    end
    order.open!
    order.save!
  end

  def process_sent_buy_order(order)
    cash_position = order.account.get_cash_position
    cash_position.lockup(order.value)
    cash_position.save!
  end

end
