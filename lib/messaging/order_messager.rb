module OrderMessager

  include TorqueBox::Injectors

  def send_open_order(order)
    message = {
      type: Order.statuses.open(true).to_s,
      product_id: order.product.id,
      order_id: order.id
    }
    properties = prod_ord_message_properties_template(order.product.id)
    prod_ord_queue.publish(message, properties: properties)
    true
  end

  private

  def prod_ord_queue
    @prod_ord_queue ||= inject('/queues/trade/prod_ord')
  end

  def prod_ord_message_properties_template(product_id)
    {'JMSXGroupID' => product_id.to_s, '_HQ_GROUP_ID' => product_id.to_s}
  end

end
