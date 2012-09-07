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
        let(:transactions) { subject.transactions }
        let(:transaction_1) { transactions.to_a[0] }
        let(:buy_account) { buy_order.account }
        let(:sell_account) { sell_order.account }
        its(:buy_order) { should == buy_order }
        its(:sell_order) { should == sell_order }
        it { should have(4).transactions }
        it 'should have valid transactions' do
          transaction_1.should_not be_nil
          transaction_1.transaction_type.should == AccountTransaction.transaction_types.debit(true)
          transaction_1.account.should == buy_account
        end
      end

      let(:product) { create(:product) }

      let(:buy_order_factory) { raise ArgumentError }
      let(:buy_price) { raise ArgumentError }
      let(:buy_quantity) { 1000 }
      let(:buy_order) { create(buy_order_factory, price: buy_price, quantity: buy_quantity, product: product) }

      let(:sell_price) { raise ArgumentError }
      let(:sell_quantity) { 1000 }
      let(:sell_order) { raise ArgumentError }

      subject { Trade.create_trade(buy_order, sell_order) }

      context 'buy limit order' do
        let(:buy_order_factory) { :pending_buy_limit_order }

        context 'sell limit order' do
          let(:sell_order) { create(:pending_sell_limit_order, price: buy_price, quantity: buy_quantity, product: product) }

          context 'buy order price greater than sell order price' do
            let(:buy_price) { 0.75 }
            let(:sell_price) { buy_price/3 }
            it_behaves_like :created_trade
            its(:quantity) { should == 1000 }
          end

        end

      end

    end # create trade

  end # class methods

end
