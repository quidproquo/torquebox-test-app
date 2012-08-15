require 'lib/messaging/sent_order_processor'
require 'lib/messaging/cancelled_order_processor'

class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include SentOrderProcessor
  include CancelledOrderProcessor

  def on_message(body)
    puts "Processing message: #{body}"

    type = body[:type]
    order_ids = body[:order_ids]

    case type
    when 'sent_orders'
      process_sent_order_ids(order_ids)
    when 'cancelled_orders'
      process_cancelled_order_ids(order_ids)
    end
    
    puts "Processing message: #{body}!"
    true
  end

end
