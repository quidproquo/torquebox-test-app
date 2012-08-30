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
      let(:account) { create(:rich_account) }
      let(:product) { create(:product) }
      let(:orders) { [] }
      let(:order_ids) { orders.collect(&:id) }
      let(:process_result) { subject.process_sent_order_ids(product.id, order_ids) }

      before do
        pending_orders
        sent_orders
        process_result
      end

      context 'single open buy limit order' do
        let(:order_price) { 0.5 }
        let(:order_quantity) { 100 }
        let(:order) { create(:sent_buy_limit_order, price: order_price, quantity: order_quantity, account: account, product: product) }
        let(:orders) { [order] }



      end # single open buy limit order

    end # process_sent_order_ids

  end # methods

end
