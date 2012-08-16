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

    describe :process_sent_order_ids do
      let(:product) { create(:product) }
      let(:order_book) { [] }
      let(:orders) { [] }
      let(:order_ids) { orders.collect(&:id) }
      let(:process_result) { subject.process_sent_order_ids(product.id, order_ids) }
      let(:trades) { Trade.all }

      context :buy_order_message do
        let(:orders) { [create(:buy_market_order)] }
        it 'should process the order' do
          process_result.should == true
        end
      end

      context 'single sent buy limit order' do
        let(:price) { 0.5 }
        let(:quantity) { 100 }
        let(:order) { create(:sent_buy_limit_order, price: price, quantity: quantity, product: product) }
        let(:orders) { [order] }

        context 'with single pending sell limit order' do
          let(:pending_limit_order_price) { nil }
          let(:pending_limit_order_quantity) { nil }
          let(:pending_limit_order) { @pending_limit_order }
          let(:order_book) { [pending_limit_order] }
          before do
            @pending_limit_order = create(:pending_sell_limit_order, price: pending_limit_order_price, quantity: pending_limit_order_quantity, product: order.product)
          end

          context 'where pending sell limit order has same price and quantity' do
            let(:pending_limit_order_price) { order.price }
            let(:pending_limit_order_quantity) { order.quantity }
            it 'should process the order and create trades' do
              process_result.should == true
              trades.length.should == 1
            end
          end

        end

      end # single sent buy limit order

    end # process_sent_order_ids

  end # methods

end
