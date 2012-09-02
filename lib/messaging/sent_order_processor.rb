module SentOrderProcessor

  def process_sent_orders(orders)
    orders.each { |order| process_sent_order(order) }
  end

  def process_sent_order(order)
    order.sent!

    if order.market?
      process_sent_market_order(order)
    elsif order.limit?
      process_sent_limit_order(order)
    end

    unless order.rejected?
      order.open!
      order.save!
      send_open_order(order)
    else
      order.save!
    end
  end

  def process_sent_market_order(order)
    if order.price.present?
      process_sent_order_by_side(order)
    else
      order.reject!("Rejected because market price for this product doesn't exist yet")
    end
  end

  def process_sent_limit_order(order)
    process_sent_order_by_side(order)
  end

  def process_sent_order_by_side(order)
    if order.buy?
      process_sent_buy_order(order)
    elsif order.sell?
      process_sent_sell_order(order)
    end
  end

  def process_sent_buy_order(order)
    cash_position = order.account.get_cash_position
    if cash_position.can_lockup?(order.value)
      cash_position.lockup(order.value)
      cash_position.save!
    else
      order.reject!("Rejected due to insufficient shares")
    end
  end

  def process_sent_sell_order(order)
    position = order.account.get_position(order.product)
    if position.can_lockup?(order.quantity)
      position.lockup(order.quantity)
      position.save!
    else
      order.reject!("Rejected due to insufficient funds")
    end
  end

  def send_open_order(order)

  end

end
