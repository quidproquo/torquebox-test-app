require 'spec_helper'

describe Trade do

  describe :associations do
    it { should belong_to(:buy_account) }
    it { should belong_to(:sell_account) }
    it { should belong_to(:product) }
    it { should belong_to(:buy_order) }
    it { should belong_to(:sell_order) }
    it { should have_many(:transactions) }
  end


  describe :class_methods do
    subject { Trade }

    describe :create_trade do
      shared_examples_for :created_trade do
        it { should have(4).transactions }
        its(:buy_order) { should == buy_order }
        its(:sell_order) { should == sell_order }
      end

      let(:product) { create(:product) }

      let(:buy_price) { raise ArgumentError }
      let(:buy_quantity) { 1000 }
      let(:buy_order) { raise ArgumentError }

      let(:sell_price) { raise ArgumentError }
      let(:sell_quantity) { 1000 }
      let(:sell_order) { raise ArgumentError }

      subject { Trade.create_trade(buy_order, sell_order) }

      context 'buy limit order' do
        let(:buy_order) { create(:pending_buy_limit_order, price: buy_price, quantity: buy_quantity, product: product) }

        context 'sell limit order' do
          let(:sell_order) { create(:pending_sell_limit_order, price: buy_price, quantity: buy_quantity, product: product) }

          context 'buy order price greater than sell order price' do
            let(:buy_price) { 0.75 }
            let(:sell_price) { buy_price/3 }
            it_behaves_like :created_trade
          end

        end

      end

    end

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
