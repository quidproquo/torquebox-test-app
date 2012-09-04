module OrderMessager

  include TorqueBox::Injectors

  def send_sent_orders(orders)
    acc_id_orders = orders.inject({}) { |hash,o| hash[o.account_id] ||= []; hash[o.account_id] << o; hash }
    acc_id_orders.each { |account_id, orders|
      send_sent_orders_by_account_id(account_id, orders)
    }
    true
  end

  def send_sent_orders_by_account_id(account_id, orders)
    message = {
      type: Order.statuses.sent(true).to_s,
      account_id: account_id,
      orders: orders.collect { |order|
        order.to_hash
      }
    }
    properties = acc_pos_message_properties_template(account_id)
    acc_pos_queue.publish(message, properties: properties)
    true
  end

  def send_open_order(order)
    message = {
      type: Order.statuses.open(true).to_s,
      product_id: order.product.id,
      order_ids: [order.id]
    }
    properties = prod_ord_message_properties_template(order)
    prod_ord_queue.publish(message, properties: properties)
    true
  end

  def acc_pos_queue
    @acc_pos_queue ||= inject('/queues/trade/acc_pos')
  end

  def acc_pos_queue=(queue)
    @acc_pos_queue = queue
  end

  def prod_ord_queue
    @prod_ord_queue ||= inject('/queues/trade/prod_ord')
  end

  def acc_pos_message_properties_template(account_id)
    {'JMSXGroupID' => account_id.to_s, '_HQ_GROUP_ID' => account_id.to_s}
  end

  def prod_ord_message_properties_template(order)
    {'JMSXGroupID' => order.product_id.to_s, '_HQ_GROUP_ID' => order.product_id.to_s}
  end

end
