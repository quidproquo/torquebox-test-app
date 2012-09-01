require 'spec_helper'
require 'lib/messaging/acc_pos_message_processor'


describe AccPosMessageProcessor do

  let(:account) { create(:account) }
  let(:account_id) { account.id }
  let(:product) { create(:product) }
  let(:product_id) { product.id }

  subject { AccPosMessageProcessor.new }

  describe :initialize do

    describe :new do
      subject { AccPosMessageProcessor.new }
      it { should be_an_instance_of(AccPosMessageProcessor) }
    end

  end #initialize

  describe :modules do
    it { should respond_to(:process_sent_orders) }
  end

  describe :methods do

    describe :on_message do
      let(:on_message_result) { subject.on_message(message) }

      context :sent_orders do
        let(:orders) { 3.times.collect { build(:order, account: account, product: product) } }
        let(:message_type) { Order.statuses.sent(true).to_s }
        let(:message) { {type: message_type, account_id: account_id,
          orders: orders.collect do |order|
            {account_id: order.account.id, product_id: order.product.id, order_type: order.order_type.to_s,
              price: order.price, quantity: order.quantity
            }
          end
        } }

        before do
          subject.should_receive(:process_sent_orders).with { |*args|
            args.pop.each_with_index { |order, index|
              expected_order = orders[index]
              order.account_id.should == expected_order.account_id
              order.product_id.should == expected_order.product_id
              order.price.should == expected_order.price
              order.quantity.should == expected_order.quantity
            }
          }
        end

        context :buy_order_message do
          let(:orders) { [build(:buy_market_order)] }
          it 'should process the message' do
            on_message_result.should == true
          end
        end

      end #sent_orders

    end #on_message

  end #methods

end
