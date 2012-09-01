require 'spec_helper'
require 'lib/messaging/sent_order_processor'

class DummySentOrderProcessor

  include SentOrderProcessor

end

describe SentOrderProcessor do

  subject { DummySentOrderProcessor.new }

  describe :initialize do

    describe :new do
      subject { DummySentOrderProcessor.new }
      it { should be_kind_of(SentOrderProcessor) }
    end

  end #initialize

  describe :methods do

    describe :process_sent_orders do
      let(:account) { create(:account) }
      let(:product) { create(:product) }
      let(:position) { account.get_position(:product) }
      let(:orders) { [] }
      let(:process_result) { subject.process_sent_orders(orders) }

      before do
        process_result
      end

      context 'when single buy limit order' do
        let(:order_price) { 0.5 }
        let(:order_quantity) { 100 }
        let(:order) { build(:buy_limit_order, price: order_price, quantity: order_quantity, account: account, product: product) }
        let(:orders) { [order] }
        it 'then orders should all be sent' do
          orders.each { |order|
            order.status.should == Order.statuses.sent(true)
          }
        end

      end # single buy limit order

    end # process_sent_orders

  end # methods

end
