require 'spec_helper'
require 'lib/messaging/open_order_processor'

class DummyOpenOrderProcessor

  include OpenOrderProcessor

end

describe OpenOrderProcessor do

  subject { DummyOpenOrderProcessor.new }

  describe :initialize do

    describe :new do
      subject { DummyOpenOrderProcessor.new }
      it { should be_kind_of(OpenOrderProcessor) }
    end

  end #initialize

  describe :methods do

    describe :process_open_order_ids do
      let(:product) { create(:product) }
      let(:pending_orders) { [] }
      let(:orders) { [] }
      let(:order_ids) { orders.collect(&:id) }
      let(:process_result) { subject.process_open_order_ids(product.id, order_ids) }
      let(:trades) { Trade.all }

      before do
        pending_orders
        orders
        process_result
        orders.map(&:reload)
        pending_orders.map(&:reload)
      end

      context 'single open buy limit order' do
        let(:order_price) { 0.5 }
        let(:order_quantity) { 1000 }
        let(:order) { create(:open_buy_limit_order, price: order_price, quantity: order_quantity, product: product) }
        let(:orders) { [order] }

        context 'with no pending sell limit orders' do
          it { process_result.should == true }
          it { trades.length.should == 0 }
        end

        context 'with single pending sell limit order' do
          let(:pending_order_price) { nil }
          let(:pending_order_quantity) { nil }
          let(:pending_order) { create(:pending_sell_limit_order, price: pending_order_price, quantity: pending_order_quantity, product: product) }
          let(:pending_orders) { [pending_order] }

          context 'where pending sell limit order has same price and quantity' do
            let(:pending_order_price) { order.price }
            let(:pending_order_quantity) { order.quantity }
            before do
              true
            end
            it { process_result.should == true }
            it { trades.length.should == 1 }
          end

        end

        context 'multiple pending sell limit orders' do
          let(:pending_orders) {
            [
              create(:pending_sell_limit_order, price: order_price, quantity: 500, product: product),
              create(:pending_sell_limit_order, price: order_price, quantity: 250, product: product),
            ]
          }
          it 'should process the trades' do
            trades.length.should == 2
            pending_orders.each { |o| o.should be_filled }
          end
        end

      end # single open buy limit order

    end # process_open_order_ids

  end # methods

end
