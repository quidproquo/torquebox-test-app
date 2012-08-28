require 'lib/messaging/new_order_processor'
require 'lib/messaging/sent_order_processor'
require 'lib/messaging/cancelled_order_processor'

class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include NewOrderProcessor
  include SentOrderProcessor
  include CancelledOrderProcessor

  def on_message(body)
    puts "Processing message: #{body}"

    type = body[:type]
    product_id = body[:product_id]
    order_ids = body[:order_ids]

    if type == 'new_orders'
      side = body[:side]
      price = body[:price]
      quantity = body[:quantity]
      order = process_new_order(side, price, quantity)
      orders = [order]
      order_ids = orders.collect(&:id)
      type = 'sent_orders'
    end

    case type
    when 'sent_orders'
      process_sent_order_ids(product_id, order_ids)
    when 'cancelled_orders'
      process_cancelled_order_ids(order_ids)
    end

    puts "Processing message: #{body}!"
    true
  end

end
