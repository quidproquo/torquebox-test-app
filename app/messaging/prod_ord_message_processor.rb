class ProdOrdMessageProcessor < TorqueBox::Messaging::MessageProcessor

  def on_message(body)
    puts "Processing message: #{body}"
    sleep(2)
    puts "Processing message: #{body}!"
  end

end
