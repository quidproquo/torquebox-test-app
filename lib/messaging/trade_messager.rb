module TradeMessager

  include TorqueBox::Injectors

  def send_sent_trades(trades)
    acc_id_transactions = trades.each_with_object({}) { |trade, hash|
      trade.transactions.each { |transaction|
        transactions = (hash[transaction.account_id] ||= [])
        transactions << transaction
      }
    }

    acc_id_transactions.each { |account_id, transactions|
      send_sent_transactions_by_account_id(account_id, transactions)
    }
    true
  end

  def send_sent_transactions_by_account_id(account_id, transactions)
    message = {
      type: 'sent_transactions',
      account_id: account_id,
      transaction_ids: transactions.map(&:id)
    }
    properties = acc_pos_message_properties_template(account_id)
    acc_pos_queue.publish(message, properties: properties)
    true
  end

  def acc_pos_queue
    @acc_pos_queue ||= inject('/queues/trade/acc_pos')
  end

  def acc_pos_queue=(queue)
    @acc_pos_queue = queue
  end

  def acc_pos_message_properties_template(account_id)
    {'JMSXGroupID' => account_id.to_s, '_HQ_GROUP_ID' => account_id.to_s}
  end

end
