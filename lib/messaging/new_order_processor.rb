module NewOrderProcessor

  def process_new_order(side, price, quantity)
    order = Order.new
    order.status = 'sent'
    order.type = 'limit'
    order.side = side
    order.price = price
    order.quantity = quantity
    order.product = Product.find_or_create_by_id(1)
    order.account = Account.find_or_create_by_id(1)
    order.date_sent = Time.now
    order.save!
    order
  end

end
