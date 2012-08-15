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
      let(:orders) { 3.times.collect { create(:order) } }
      let(:order_ids) { orders.collect(&:id) }
      let(:process_result) { subject.process_sent_order_ids(order_ids) }
      let(:trades) { Trade.all }

      context :buy_order_message do
        let(:orders) { [create(:buy_market_order)] }
        it 'should process the order' do
          process_result.should == true
        end
      end

      context 'buy_limit_order' do
        let(:order) { create(:buy_limit_order) }
        let(:orders) { [order] }

        context 'with single sell limit order in the book' do
          before do
            create(:sell_limit_order, status: 'pending', product: order.product)
          end
          it 'should process the order and create a trade' do
            process_result.should == true
            trades.length.should == 2
          end

        end

      end

    end #process_sent_order_ids

  end #methods

end
