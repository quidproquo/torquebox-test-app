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
      let(:pending_orders) { [] }
      let(:sent_orders) { [] }
      let(:sent_order_ids) { sent_orders.collect(&:id) }
      let(:process_result) { subject.process_sent_order_ids(product.id, sent_order_ids) }
      let(:trades) { Trade.all }

      before do
        pending_orders
        sent_orders
        process_result
      end                                

      context 'single sent buy limit order' do
        let(:sent_order_price) { 0.5 }
        let(:sent_order_quantity) { 100 }
        let(:sent_order) { create(:sent_buy_limit_order, price: sent_order_price, quantity: sent_order_quantity, product: product) }
        let(:sent_orders) { [sent_order] }

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
            let(:pending_order_price) { sent_order.price }
            let(:pending_order_quantity) { sent_order.quantity }
            before do
              true
            end
            it { process_result.should == true }
            it { trades.length.should == 2 }
          end

        end

      end # single sent buy limit order

    end # process_sent_order_ids

  end # methods

end
