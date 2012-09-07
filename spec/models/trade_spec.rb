require 'spec_helper'

describe Trade do

  subject { Trade.new }

  describe :associations do
    it { should belong_to(:buy_account) }
    it { should belong_to(:sell_account) }
    it { should belong_to(:product) }
    it { should belong_to(:buy_order) }
    it { should belong_to(:sell_order) }
    it { should have_many(:transactions) }
  end

  describe :properties do

    describe :value do
      let(:price) { 0.5 }
      let(:quantity) { 100 }
      subject { build(:trade, price: price, quantity: quantity) }
      its(:value) { should == price * quantity }
    end

  end


  describe :class_methods do
    subject { Trade }

    describe :create_trade do
      shared_examples_for :created_trade do
        let(:buy_account) { buy_order.account }
        let(:sell_account) { sell_order.account }
        let(:transactions) { subject.transactions }
        let(:transaction_1) { transactions.to_a[0] }
        let(:transaction_2) { transactions.to_a[1] }
        let(:transaction_3) { transactions.to_a[2] }
        let(:transaction_4) { transactions.to_a[3] }

        its(:buy_order) { should == buy_order }
        its(:sell_order) { should == sell_order }
        its(:buy_account) { should == buy_account }
        its(:sell_account) { should == sell_account }
        its(:product) { should == buy_order.product }
        its(:price) { should == expected_price }
        its(:quantity) { should == expected_quantity }
        it { should have(4).transactions }
        it 'should have valid transactions' do
          # Debit cash from buy account
          transaction_1.should_not be_nil
          transaction_1.id.should_not be_nil
          transaction_1.transactable.should == subject
          transaction_1.transaction_type.should == AccountTransaction.transaction_types.debit(true)
          transaction_1.account.should == buy_account
          transaction_1.product.should == Product.cash_product
          transaction_1.quantity.should == subject.value
          transaction_1.cost_basis.should == 1

          # Credit shares to buy account
          transaction_2.should_not be_nil
          transaction_3.id.should_not be_nil
          transaction_2.transactable.should == subject
          transaction_2.transaction_type.should == AccountTransaction.transaction_types.credit(true)
          transaction_2.account.should == buy_account
          transaction_2.product.should == subject.product
          transaction_2.quantity.should == subject.quantity
          transaction_2.cost_basis.should == subject.price

          # Credit cash to sell account
          transaction_3.should_not be_nil
          transaction_3.id.should_not be_nil
          transaction_3.transactable.should == subject
          transaction_3.transaction_type.should == AccountTransaction.transaction_types.credit(true)
          transaction_3.account.should == sell_account
          transaction_3.product.should == Product.cash_product
          transaction_3.quantity.should == subject.value
          transaction_3.cost_basis.should == 1

          # Debit shares from sell account
          transaction_4.should_not be_nil
          transaction_4.id.should_not be_nil
          transaction_4.transactable.should == subject
          transaction_4.transaction_type.should == AccountTransaction.transaction_types.debit(true)
          transaction_4.account.should == sell_account
          transaction_4.product.should == subject.product
          transaction_4.quantity.should == subject.quantity
          transaction_4.cost_basis.should == subject.price
        end
      end

      let(:product) { create(:product) }

      let(:buy_order_factory) { raise ArgumentError }
      let(:buy_price) { raise ArgumentError }
      let(:buy_quantity) { raise ArgumentError }
      let(:buy_order) { create(buy_order_factory, price: buy_price, quantity: buy_quantity, product: product) }

      let(:sell_order_factory) { raise ArgumentError }
      let(:sell_price) { raise ArgumentError }
      let(:sell_quantity) { raise ArgumentError }
      let(:sell_order) { create(sell_order_factory, price: buy_price, quantity: buy_quantity, product: product) }

      let(:expected_price) { raise ArgumentError }
      let(:expected_quantity) { raise ArgumentError }

      subject { Trade.create_trade(buy_order, sell_order) }

      context 'same quantities' do
        let(:buy_quantity) { 1000 }
        let(:sell_quantity) { buy_quantity }
        let(:expected_quantity) { buy_quantity }

        context 'buy limit order' do
          let(:buy_order_factory) { :pending_buy_limit_order }
          let(:buy_price) { 0.75 }

          context 'sell limit order' do
            let(:sell_order_factory) { :pending_sell_limit_order }

            context 'buy order price greater than sell order price' do
              let(:sell_price) { buy_price/3 }
              let(:expected_price) { buy_price }
              it_behaves_like :created_trade
            end

            context 'buy order price equal to sell order price' do
              let(:sell_price) { buy_price }
              let(:expected_price) { buy_price }
              it_behaves_like :created_trade
            end

          end

        end # buy limit order

      end # same qtys

    end # create trade

  end # class methods

end
