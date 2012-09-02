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
      let(:position) { raise ArgumentError }
      let(:cash_position) { raise ArgumentError }
      let(:orders) { raise ArgumentError }
      let(:open_orders) { raise ArgumentError }
      let(:process_result) { subject.process_sent_orders(orders) }

      before do
        position
        cash_position
        open_orders.each { |open_order|
          subject.should_receive(:send_open_order).with(open_order)
        }
        process_result
        orders.each(&:reload)
        position.reload
        cash_position.reload
      end

      context 'rich positions' do
        let(:position) { create(:rich_position, account: account, product: product) }
        let(:cash_position) { create(:rich_cash_position, account: account) }

        context 'with buy orders' do

          context 'with buy limit orders' do

            context 'when single buy limit order' do
              let(:order_price) { 0.5 }
              let(:order_quantity) { 100 }
              let(:order) { build(:buy_limit_order, price: order_price, quantity: order_quantity, account: account, product: product) }
              let(:orders) { [order] }
              let(:open_orders) { orders }
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

          context 'with buy market orders' do

            context 'when single buy market order' do
              let(:order_price) { nil }
              let(:order_quantity) { 100 }
              let(:order) { build(:buy_market_order, price: order_price, quantity: order_quantity, account: account, product: product) }
              let(:orders) { [order] }

              context 'when product has a price' do
                let(:product) { create(:product, price: 0.5) }
                let(:open_orders) { orders }
                it 'then orders should all be open' do
                  orders.each { |order|
                    order.should be_open
                    order.date_sent.should_not be_nil
                  }
                end
                it 'should lockup amount in position' do
                  cash_position.locked_quantity.should == order.value
                end
              end # product has price

              context 'when product has no price' do
                let(:product) { create(:product, price: nil) }
                let(:open_orders) { [] }
                it 'then orders should all be rejected' do
                  orders.each { |order|
                    order.should be_rejected
                    order.date_sent.should_not be_nil
                  }
                end
                it 'should lockup amount in position' do
                  cash_position.locked_quantity.should == 0
                end
              end # product has price

            end # single buy market order

          end # buy market orders

        end # buy orders

      end # rich positions

    end # process_sent_orders

  end # methods

end
