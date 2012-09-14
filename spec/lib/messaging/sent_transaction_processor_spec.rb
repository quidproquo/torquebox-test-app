require 'spec_helper'
require 'lib/messaging/sent_transaction_processor'

class DummySentTransactionProcessor

  include SentTransactionProcessor

end

describe SentTransactionProcessor do

  subject { DummySentTransactionProcessor.new }

  describe :initialize do

    describe :new do
      subject { DummySentTransactionProcessor.new }
      it { should be_kind_of(SentTransactionProcessor) }
    end

  end #initialize

  describe :methods do

    describe :process_sent_transaction_ids do
      let(:account) { create(:account) }
      let(:cash_product) { Product.cash_product }
      let(:product) { create(:product) }
      let(:initial_cash_position_quantity) { 1000 }
      let(:initial_position_quantity) { 1000 }
      let(:trade_price) { 0.5 }
      let(:trade_quantity) { 1000 }
      let(:trade_value) { trade_price * trade_quantity }
      let!(:cash_position) { create(:position, account: account, product: cash_product, quantity: initial_cash_position_quantity, locked_quantity: trade_value) }
      let!(:position) { create(:position, account: account, product: product, quantity: initial_position_quantity, locked_quantity: 0) }
      let(:positions) { [cash_position, position] }
      let(:debit_transaction) { raise ArgumentError }
      let(:credit_transaction) { raise ArgumentError }
      let(:transactions) { [debit_transaction, credit_transaction] }
      let(:transaction_ids) { transactions.collect { |t| t.id } }

      before do
        subject.process_sent_transaction_ids(transaction_ids)
        positions.map(&:reload)
      end

      context 'based off a buy_order' do
        let(:debit_transaction) { create(:debit_transaction, account: account, product: cash_product, quantity: trade_value, cost_basis: 1) }
        let(:credit_transaction) { create(:credit_transaction, account: account, product: product, quantity: trade_quantity, cost_basis: trade_price) }

        it 'should process the transaction_ids' do
          cash_position.quantity.should == initial_cash_position_quantity - trade_value
          cash_position.locked_quantity.should == 0
          position.quantity.should == initial_position_quantity + trade_quantity
        end
      end

    end # process_sent_transaction_ids

  end # methods

end
