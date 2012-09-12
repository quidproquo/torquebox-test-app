require 'lib/messaging/sent_order_processor'

class AccPosMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include SentOrderProcessor

  def on_message(body)
    puts "Processing AccPos message: #{body}"

    case body[:type]
    when Order.statuses.sent(true).to_s
      orders = body[:orders].collect { |order|
        Order.new(order)
      }
      process_sent_orders(orders)
    end

    puts "Processing AccPos message: #{body}!"
    true
  end

end
