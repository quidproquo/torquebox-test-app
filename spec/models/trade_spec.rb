require 'spec_helper'

describe Trade do

  describe :class_methods do
    subject { Trade }

    describe :create_trades do
      let(:product) { create(:product) }
      
      let(:order1_price) { 0.5 }
      let(:order1_quantity) { 100 }
      let(:order1) { create(:pending_buy_limit_order, price: order1_price, quantity: order1_quantity, product: product) }

      let(:order2_price) { 0.5 }
      let(:order2_quantity) { 100 }
      let(:order2) { create(:pending_sell_limit_order, price: order2_price, quantity: order2_quantity, product: product) }

      subject { Trade.create_trades(order1, order2) }

      context 'where price and quantities match' do
        its(:length) { should == 2 }
      end

    end

  end

end
