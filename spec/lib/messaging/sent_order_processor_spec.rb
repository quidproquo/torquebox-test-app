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
      let(:position) { account.get_position(product) }
      let(:cash_position) { create(:rich_cash_position, account: account) }
      let(:orders) { [] }
      let(:process_result) { subject.process_sent_orders(orders) }

      before do
        cash_position
        process_result
        orders.each(&:reload)
        cash_position.reload
      end

      context 'with buy orders' do

        context 'with buy limit orders' do

          context 'when single buy limit order' do
            let(:order_price) { 0.5 }
            let(:order_quantity) { 100 }
            let(:order) { build(:buy_limit_order, price: order_price, quantity: order_quantity, account: account, product: product) }
            let(:orders) { [order] }
            it 'then orders should all be open' do
              orders.each { |order|
                order.should be_open
                order.date_sent.should_not be_nil
              }
            end
            it 'should lockup amount in position' do
              cash_position.locked_quantity.should == order.value
            end
          end # single buy limit order

        end # buy limit orders

      end # buy orders

    end # process_sent_orders

  end # methods

end
