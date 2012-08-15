require 'spec_helper'
require 'lib/messaging/prod_ord_message_processor'


describe ProdOrdMessageProcessor do

  before do
    ProdOrdMessageProcessor.any_instance.stub(:process_sent_order_ids) { |ids|
      orders.find(ids).each { |order|
        order.status = 'pending'
        order.save!
      }
    }
  end

  after do
    ProdOrdMessageProcessor.any_instance.unstub(:process_sent_order_ids)
  end

  subject { ProdOrdMessageProcessor.new }

  describe :initialize do
  
    describe :new do
      subject { ProdOrdMessageProcessor.new }
      it { should be_an_instance_of(ProdOrdMessageProcessor) }
    end

  end #initialize

  describe :methods do

    describe :on_message do
      let(:orders) { nil }
      let(:order_ids) { orders.collect(&:id) }
      let(:message) { nil }
      let(:on_message_result) { subject.on_message(message) }

      context :sent_orders do
        let(:message) { {type: 'sent_orders', order_ids: order_ids} }

        context :buy_order_message do
          let(:orders) { [create(:buy_market_order)] }
          before do
            subject.should_receive(:process_sent_order_ids).with(order_ids)
          end
          it 'should process the message' do
            on_message_result.should == true
          end
        end

      end #sent_orders

    end #on_message

  end #methods

end
