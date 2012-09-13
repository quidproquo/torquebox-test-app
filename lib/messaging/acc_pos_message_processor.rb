require 'lib/messaging/sent_order_processor'
require 'lib/messaging/sent_transaction_processor'

class AccPosMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include SentOrderProcessor
  include SentTransactionProcessor

  def on_message(body)
    puts "Processing AccPos message: #{body}"

    case body[:type]
    when Order.statuses.sent(true).to_s
      orders = body[:orders].collect { |order|
        Order.new(order)
      }
      process_sent_orders(orders)
    when 'sent_transactions'
      process_sent_transaction_ids(body[:transaction_ids])
    end

    puts "Processing AccPos message: #{body}!"
    true
  end

end
