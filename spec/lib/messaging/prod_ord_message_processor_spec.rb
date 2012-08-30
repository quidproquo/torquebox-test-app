require 'spec_helper'
require 'lib/messaging/prod_ord_message_processor'


describe ProdOrdMessageProcessor do

  let(:product) { create(:product) }
  let(:product_id) { product.id }

  subject { ProdOrdMessageProcessor.new }

  describe :initialize do

    describe :new do
      subject { ProdOrdMessageProcessor.new }
      it { should be_an_instance_of(ProdOrdMessageProcessor) }
    end

  end #initialize

  describe :modules do
    it { should respond_to(:process_open_order_ids) }
    it { should respond_to(:process_cancelled_order_ids) }
  end

  describe :methods do

    describe :on_message do
      let(:orders) { 3.times.collect { create(:order, product: product) } }
      let(:order_ids) { orders.collect(&:id) }
      let(:message_type) { nil }
      let(:message) { {type: message_type, product_id: product_id, order_ids: order_ids} }
      let(:on_message_result) { subject.on_message(message) }

      context :sent_orders do
        let(:message_type) { 'open_orders' }
        before do
          subject.should_receive(:process_open_order_ids).with(product_id, order_ids)
        end

        context :buy_order_message do
          let(:orders) { [create(:buy_market_order)] }
          it 'should process the message' do
            on_message_result.should == true
          end
        end

      end #sent_orders

      context :cancelled_orders do
        let(:message_type) { 'cancelled_orders' }
        before do
          subject.should_receive(:process_cancelled_order_ids).with(order_ids)
        end

        context :buy_order_message do
          let(:orders) { [create(:buy_market_order)] }
          it 'should process the message' do
            on_message_result.should == true
          end
        end

      end #cancelled_orders

    end #on_message

  end #methods

end
