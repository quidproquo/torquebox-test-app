require 'spec_helper'
require 'lib/messaging/order_messager'

class DummyOrderMessager

  include OrderMessager

end

describe OrderMessager do

  let(:queue) { double('queue') }
  subject { DummyOrderMessager.new }

  describe :initialize do

    describe :new do
      subject { DummyOrderMessager.new }
      it { should be_kind_of(OrderMessager) }
    end

  end #initialize

  describe :methods do

    describe :send_sent_orders do
      let(:orders) { raise ArgumentError }
      let(:account_id) { order.account.id }
      let(:expected_message) { raise ArgumentError }
      let(:expected_properties) { {'JMSXGroupID' => account_id.to_s, '_HQ_GROUP_ID' => account_id.to_s} }
      let(:method_result) { subject.send_sent_orders(orders) }

      before do
       subject.should_receive(:inject).with('/queues/trade/acc_pos').and_return(queue)
       queue.should_receive(:publish).with(expected_message, properties: expected_properties)
      end

      context 'buy market order' do
        let(:order) { create(:buy_market_order) }
        let(:orders) { [order] }
        let(:expected_message) {
          {
            type: Order.statuses.sent(true).to_s,
            account_id: order.account_id,
            orders: orders.collect { |order|
              order.to_hash
            }
          }
        }
        it 'should send order' do
          method_result.should == true
        end
      end

    end # send_open_order

    describe :send_open_order do
      let(:order) { raise ArgumentError }
      let(:product_id) { order.product.id }
      let(:expected_message) { raise ArgumentError }
      let(:expected_properties) { {'JMSXGroupID' => product_id.to_s, '_HQ_GROUP_ID' => product_id.to_s} }
      let(:method_result) { subject.send_open_order(order) }

      before do
       subject.should_receive(:inject).with('/queues/trade/prod_ord').and_return(queue)
       queue.should_receive(:publish).with(expected_message, properties: expected_properties)
      end

      context 'buy market order' do
        let(:order) { create(:open_buy_market_order) }
        let(:expected_message) {
          {type: Order.statuses.open(true).to_s, product_id: order.product.id,
           order_ids: [order.id]}
        }
        it 'should send order' do
          method_result.should == true
        end
      end

    end # send_open_order

  end # methods

end
