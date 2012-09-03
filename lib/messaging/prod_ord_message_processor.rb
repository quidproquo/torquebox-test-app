require 'lib/messaging/open_order_processor'
require 'lib/messaging/sent_order_processor'
require 'lib/messaging/cancelled_order_processor'

class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include OpenOrderProcessor
  include CancelledOrderProcessor

  def on_message(body)
    puts "Processing message: #{body}"

    type = body[:type]
    product_id = body[:product_id]
    order_ids = body[:order_ids]

    case type
    when Order.statuses.open(true).to_s
      process_open_order_ids(product_id, order_ids)
    when Order.statuses.cancelled(true).to_s
      process_cancelled_order_ids(order_ids)
    end

    puts "Processing message: #{body}!"
    true
  end

end
