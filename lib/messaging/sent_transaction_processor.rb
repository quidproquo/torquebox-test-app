
module SentTransactionProcessor

  def process_sent_transaction_ids(transaction_ids)
    puts "process_sent_trasaction_ids(#{transaction_ids})"
    transactions = AccountTransaction.find(transaction_ids)
    account = transactions.first.account
    transactions.each do |t|
      position = Position.find_by_account_id_and_product_id!(t.account_id, t.product_id)
      if t.debit?
        position.debit(t.quantity)
        position.unlock(t.quantity)
      elsif t.credit?
        position.credit(t.quantity)
      end
      position.save!
      t.save!
    end
  end

end
