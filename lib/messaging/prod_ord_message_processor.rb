require 'lib/messaging/open_order_processor'
require 'lib/messaging/sent_order_processor'
require 'lib/messaging/cancelled_order_processor'

class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include SentOrderProcessor
  include OpenOrderProcessor
  include CancelledOrderProcessor

  def on_message(body)
    puts "Processing message: #{body}"

    return true

    type = body[:type]
    product_id = body[:product_id]
    order_ids = body[:order_ids]

    if type == 'sent_orders'
      side = body[:side]
      price = body[:price]
      quantity = body[:quantity]
      order = process_sent_order(side, price, quantity)
      orders = [order]
      order_ids = orders.collect(&:id)
      type = 'sent_orders'
    end

    case type
    when 'open_orders'
      process_open_order_ids(product_id, order_ids)
    when 'cancelled_orders'
      process_cancelled_order_ids(order_ids)
    end

    puts "Processing message: #{body}!"
    true
  end

end
