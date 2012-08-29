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
      let(:account) { create(:rich_account) }
      let(:product) { create(:product) }
      let(:orders) { [] }
      let(:order_ids) { sent_orders.collect(&:id) }
      let(:process_result) { subject.process_open_order_ids(product.id, order_ids) }

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

    end # process_open_order_ids

  end # methods

end
