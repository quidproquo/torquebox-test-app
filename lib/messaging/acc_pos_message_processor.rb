require 'lib/messaging/sent_order_processor'

class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  include OpenOrderProcessor

  def on_message(body)
    puts "Processing message: #{body}"

    body = Hashie::Mash.new(body)
    orders = []

    case body.type
    when 'sent_orders'
      orders = process_sent_order(product_id, order_ids)
    end

    puts "Processing message: #{body}!"
    true
  end

end
