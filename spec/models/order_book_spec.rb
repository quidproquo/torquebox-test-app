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

    end

  end

end
