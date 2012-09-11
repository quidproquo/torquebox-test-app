require 'spec_helper'
require 'lib/messaging/trade_messager'

class DummyTradeMessager

  include TradeMessager

end

describe TradeMessager do

  let(:queue) { double('queue') }
  subject { DummyTradeMessager.new }

  describe :initialize do

    describe :new do
      subject { DummyTradeMessager.new }
      it { should be_kind_of(TradeMessager) }
    end

  end #initialize

  describe :methods do

    describe :send_sent_trades do
      let(:product) { create(:product) }
      let(:trades) { raise ArgumentError }
      let(:expected_envelopes) { raise ArgumentError }
      let(:method_result) { subject.send_sent_trades(trades) }

      before do
       subject.should_receive(:inject).with('/queues/trade/acc_pos').and_return(queue)
       expected_envelopes.each { |e|
         queue.should_receive(:publish).with(e[:message], properties: e[:properties])
       }
      end

      context 'single trade' do
        let(:buy_order) { create(:pending_buy_limit_order, product: product) }
        let(:sell_order) { create(:pending_sell_limit_order, product: product) }
        let(:trade) { create(:trade, buy_order: buy_order, sell_order: sell_order, product: product) }
        let(:buy_transactions) { trade.transactions.select { |trans| trans.account_id == buy_order.account.id } }
        let(:sell_transactions) { trade.transactions.select { |trans| trans.account_id == sell_order.account.id } }
        let(:trades) { [trade] }
        let(:expected_buy_envelope) { {
          message: {
            type: 'sent_transactions',
            account_id: buy_order.account_id,
            transaction_ids: buy_transactions.map(&:id)
          },
          properties: {
            'JMSXGroupID' => buy_order.account_id.to_s,
            '_HQ_GROUP_ID' => buy_order.account_id.to_s
          }
        } }
        let(:expected_sell_envelope) { {
          message: {
            type: 'sent_transactions',
            account_id: sell_order.account_id,
            transaction_ids: sell_transactions.map(&:id)
          },
          properties: {
            'JMSXGroupID' => sell_order.account_id.to_s,
            '_HQ_GROUP_ID' => sell_order.account_id.to_s
          }
        } }
        let(:expected_envelopes) { [expected_buy_envelope, expected_sell_envelope] }
        it 'should send trades' do
          method_result.should == true
        end
      end

    end # send_sent_trades

  end # methods

end
