require 'lib/messaging/sent_order_processor'

class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include SentOrderMessageProcessor

  def on_message(body)
    puts "Processing message: #{body}"
    process_sent_order_ids(body[:order_ids])
    puts "Processing message: #{body}!"
    true
  end

end
