require 'spec_helper'

describe OrderBook do
  let(:product) { create(:product) }
  let(:product_id) { product.id }
  subject { OrderBook.new(product_id) }

  describe :initialize do

    context 'with product id' do
      subject { OrderBook.new(product_id) }
      its(:product) { should == product }
    end

  end

  describe :methods do

    describe :add_order do
      let(:order) { create(:order) }
      before do
        subject.add_order(order)
      end
      
      context 'when order is a buy market order' do
        let(:order) { create(:pending_buy_market_order) }
        it { should have(1).orders }
        it { should have(1).buy_orders }
        it { should have(1).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(0).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end
      
      context 'when order is a buy limit order' do
        let(:order) { create(:pending_buy_limit_order) }
        it { should have(1).orders }
        it { should have(1).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(1).buy_limit_orders }
        it { should have(0).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end
      
      context 'when order is a sell market order' do
        let(:order) { create(:pending_sell_market_order) }
        it { should have(1).orders }
        it { should have(0).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(1).sell_orders }
        it { should have(1).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end
      
      context 'when order is a sell limit order' do
        let(:order) { create(:pending_sell_limit_order) }
        it { should have(1).orders }
        it { should have(0).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(1).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(1).sell_limit_orders }
      end

    end # add_order

    describe :remove_order do
      let(:order) { create(:order) }
      before do
        subject.add_order(order)
        subject.remove_order(order)
      end
      
      context 'when order is a buy market order' do
        let(:order) { create(:pending_buy_market_order) }
        it { should have(0).orders }
        it { should have(0).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(0).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end
      
      context 'when order is a buy limit order' do
        let(:order) { create(:pending_buy_limit_order) }
        it { should have(0).orders }
        it { should have(0).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(0).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end
      
      context 'when order is a sell market order' do
        let(:order) { create(:pending_sell_market_order) }
        it { should have(0).orders }
        it { should have(0).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(0).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end
      
      context 'when order is a sell limit order' do
        let(:order) { create(:pending_sell_limit_order) }
        it { should have(0).orders }
        it { should have(0).buy_orders }
        it { should have(0).buy_market_orders }
        it { should have(0).buy_limit_orders }
        it { should have(0).sell_orders }
        it { should have(0).sell_market_orders }
        it { should have(0).sell_limit_orders }
      end

    end # remove_order

    describe :get_matching_orders do
      let(:order) { nil }
      let(:orders) { [] }
      let(:matching_orders) { subject.get_matching_orders(order) }
      before { subject.add_orders(orders) }

      context 'limit order' do
        let(:order_price) { nil }

        context 'buy limit order' do
          let(:order) { create(:pending_buy_limit_order, price: order_price) }

          context 'sell limit orders in book' do
            let(:date_sent) { order.date_sent - 1 }
            let(:orders) { [
              create(:pending_sell_limit_order, price: 0.25, date_sent: date_sent),
              create(:pending_sell_limit_order, price: 0.35, date_sent: date_sent),
              create(:pending_sell_limit_order, price: 0.40, date_sent: date_sent),
              create(:pending_sell_limit_order, price: 0.50, date_sent: date_sent),
              create(:pending_sell_limit_order, price: 0.60, date_sent: date_sent)
            ] }

            context 'order price doesnt match order book prices' do
              let(:order_price) { 0.10 }
              it { matching_orders.should == [] }
            end

            context 'order price matches first order' do
              let(:order_price) { 0.25 }
              it { matching_orders.should == [orders[0]] }
            end

            context 'order price falls in middle of order book prices' do
              let(:order_price) { 0.40 }
              it { matching_orders.should == [orders[0], orders[1], orders[2]] }
            end

            context 'order price matches all order book prices' do
              let(:order_price) { 0.70 }
              it { matching_orders.should == subject.sell_limit_orders }
            end

          end

        end # buy limit order

        context 'sell limit order' do
          let(:order) { create(:pending_sell_limit_order, price: order_price) }

          context 'buy limit orders in book' do
            let(:date_sent) { order.date_sent - 1 }
            let(:orders) { [
              create(:pending_buy_limit_order, price: 0.60, date_sent: date_sent),
              create(:pending_buy_limit_order, price: 0.50, date_sent: date_sent),
              create(:pending_buy_limit_order, price: 0.40, date_sent: date_sent),
              create(:pending_buy_limit_order, price: 0.35, date_sent: date_sent),
              create(:pending_buy_limit_order, price: 0.25, date_sent: date_sent)
            ] }

            context 'order price doesnt match order book prices' do
              let(:order_price) { 0.70 }
              it { matching_orders.should == [] }
            end

            context 'order price falls in middle of order book prices' do
              let(:order_price) { 0.40 }
              it { matching_orders.should == [orders[0], orders[1], orders[2]] }
            end

            context 'order price matches all order book prices' do
              let(:order_price) { 0.10 }
              it { matching_orders.should == subject.buy_limit_orders }
            end

          end

        end # sell limit order

      end # limit order

    end # get_matching_orders

  end #methods

  describe :class_methods do

    describe :find_by_product_id do
      let(:product) { create(:product) }
      let(:pending_orders) { [] }
      subject { OrderBook.find_by_product_id(product.id) }
      before {
        pending_orders
      }

      context 'when there are no pending orders' do
        let(:pending_orders) { [] }
        its(:product) { should == product }
        it { should have(0).orders }
      end

      context 'when there are some pending orders' do
        let(:pending_orders) { [
          create(:pending_buy_limit_order, product: product),
          create(:pending_buy_market_order, product: product),
          create(:pending_sell_limit_order, product: product),
          create(:pending_sell_market_order, product: product),
        ] }
        its(:product) { should == product }
        its(:orders) { should == pending_orders }
      end

    end

  end # class_methods

end
