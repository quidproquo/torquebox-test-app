require 'spec_helper'

describe Order do

  subject { Order.new }

  describe :initialize do

    context :new do
      subject { Order.new }
      it { should be_an_instance_of(Order) }
    end

    context :factory do

      context :buy_market_order do
        subject { build(:buy_market_order) }
        it { should be_valid }
      end

    end

  end # initialize

  describe :associations do
    it { should belong_to(:product) }
    it { should belong_to(:account) }
  end

  describe :validation do

    describe :fields do

      describe :status do
        it { should validate_presence_of(:status) }
      end

      describe :order_type do
        it { should validate_presence_of(:order_type) }
      end

      describe :side do
        it { should validate_presence_of(:side) }
      end

      describe :price do
        it { should validate_presence_of(:price) }
      end

      describe :original_quantity do
        it { should validate_presence_of(:original_quantity) }
      end

      describe :pending_quantity do
        it { should validate_presence_of(:pending_quantity) }
      end

    end # fields

    describe :associations do

      describe :product do
        it { should validate_presence_of(:product) }
      end

      describe :account do
        it { should validate_presence_of(:account) }
      end

    end # associations

  end # validation

  describe :crud do

    describe :save do
      it 'should save and get from db' do
        order = build(:buy_market_order)
        order.save!
        Order.find(order.id).should == order
      end
    end

  end # crud

  describe :properties do

    describe :quantity do
      let(:quantity) { 1000 }
      before do
        subject.quantity = quantity
      end
      its(:quantity) { should == quantity }
      its(:original_quantity) { should == quantity }
      its(:pending_quantity) { should == quantity }
    end

    describe :value do
      let(:price) { raise ArgumentError }
      let(:quantity) { raise ArgumentError }
      let(:expected_value) { price * quantity }
      subject { build(:order, price: price, quantity: quantity) }

      context 'when price and quantity are not 0' do
        let(:price) { 0.5 }
        let(:quantity) { 1000 }
        its(:value) { should == expected_value }
      end

      context 'when price is 0 and quantity is not 0' do
        let(:price) { 0 }
        let(:quantity) { 1000 }
        its(:value) { should == expected_value }
      end

    end

    describe :status do

      context 'when status is set from :draft to :sent' do
        subject { build(:order) }
        before { subject.status = Order.statuses.sent(true) }
        its(:status) { should == Order.statuses.sent(true) }
        its(:date_sent) { should_not be_nil }
      end

      context 'when status is set from :draft to S' do
        subject { build(:order) }
        before { subject.status = Order.statuses.sent }
        its(:status) { should == Order.statuses.sent(true) }
        its(:date_sent) { should_not be_nil }
      end

      context 'when sent!' do
        subject { build(:order) }
        before { subject.sent! }
        its(:status) { should == Order.statuses.sent(true) }
        its(:date_sent) { should_not be_nil }
      end

    end

  end

  describe :object_methods do

    describe :<=> do
      let(:other) { nil }
      let(:comparison) { subject <=> other }
      let(:inverse_comparison) { other <=> subject }
      subject { nil }

      context 'market orders' do

        context 'buy market orders' do
          let(:other_date_sent) { nil }
          let(:other) { build(:sent_buy_market_order, date_sent: other_date_sent) }
          subject { build(:sent_buy_market_order) }

          context 'when other order is sent before subject order' do
            let(:other_date_sent) { subject.date_sent - 1 }
            it { comparison.should == 1 }
            it { inverse_comparison.should == -1 }
          end

          context 'when other order is sent at same time as subject order' do
            let(:other_date_sent) { subject.date_sent }
            it { comparison.should == 0 }
            it { inverse_comparison.should == 0 }
          end

          context 'when other order is the same as subject order' do
            let(:other) { subject }
            it { comparison.should == 0 }
            it { inverse_comparison.should == 0 }
          end

          context 'when other order is sent after time as subject order' do
            let(:other_date_sent) { subject.date_sent + 1 }
            it { comparison.should == -1 }
            it { inverse_comparison.should == 1 }
          end

        end # buy market orders

        context 'sell market orders' do
          let(:other_date_sent) { nil }
          let(:other) { build(:sent_sell_market_order, date_sent: other_date_sent) }
          subject { build(:sent_sell_market_order) }

          context 'when other order is sent before subject order' do
            let(:other_date_sent) { subject.date_sent - 1 }
            it { comparison.should == 1 }
            it { inverse_comparison.should == -1 }
          end

          context 'when other order is sent at same time as subject order' do
            let(:other_date_sent) { subject.date_sent }
            it { comparison.should == 0 }
            it { inverse_comparison.should == 0 }
          end

          context 'when other order is the same as subject order' do
            let(:other) { subject }
            it { comparison.should == 0 }
            it { inverse_comparison.should == 0 }
          end

          context 'when other order is sent after time as subject order' do
            let(:other_date_sent) { subject.date_sent + 1 }
            it { comparison.should == -1 }
            it { inverse_comparison.should == 1 }
          end

        end # sell market orders

      end # market orders

      context 'limit orders' do

        context 'buy limit orders' do
          let(:other_date_sent) { subject.date_sent }
          let(:other_price) { nil }
          let(:other) { build(:sent_buy_limit_order, price: other_price, date_sent: other_date_sent) }
          subject { build(:sent_buy_limit_order) }

          context 'when other order price is less than subject order price' do
            let(:other_price) { subject.price * 0.99 }
            it { comparison.should == -1 }
            it { inverse_comparison.should == 1 }
          end

          context 'when other order price is same as subject order price' do
            let(:other_price) { subject.price }

            context 'when other order was sent before subject order' do
              let(:other_date_sent) { subject.date_sent - 1 }
              it { comparison.should == 1 }
              it { inverse_comparison.should == -1 }
            end

            context 'when other order was sent at same time as subject order' do
              let(:other_date_sent) { subject.date_sent }
              it { comparison.should_not == 0 }
              it { inverse_comparison.should_not == 0 }
            end

            context 'when other order was sent after subject order' do
              let(:other_date_sent) { subject.date_sent + 1 }
              it { comparison.should == -1 }
              it { inverse_comparison.should == 1 }
            end

            context 'when other order is a sell limit order with same price' do
              let(:other) { build(:sent_sell_limit_order, price: other_price, date_sent: other_date_sent) }

              context 'when other orders date sent is before' do
                let(:other_date_sent) { subject.date_sent - 1 }
                it { comparison.should == 0 }
                it { inverse_comparison.should == 0 }
              end

              context 'when other orders date sent at same time' do
                let(:other_date_sent) { subject.date_sent }
                it { comparison.should == 0 }
                it { inverse_comparison.should == 0 }
              end

              context 'when other orders date sent is after' do
                let(:other_date_sent) { subject.date_sent + 1 }
                it { comparison.should == 0 }
                it { inverse_comparison.should == 0 }
              end

            end # other order is different side

          end # orders are same price

          context 'when other order is the same as subject order' do
            let(:other) { subject }
            it { comparison.should == 0 }
            it { inverse_comparison.should == 0 }
          end

          context 'when other order price is greater than subject order price' do
            let(:other_price) { subject.price * 1.01 }
            it { comparison.should == 1 }
            it { inverse_comparison.should == -1 }
          end

          context 'sorting in an array' do
            let(:date_sent) { Date.new }
            let(:orders) { [] }
            subject { orders.sort }

            context 'with orders not in sorted order' do
              let(:orders) { [
                build(:sent_buy_limit_order, price: 0.1, date_sent: date_sent),
                build(:sent_buy_limit_order, price: 0.2, date_sent: date_sent),
                build(:sent_buy_limit_order, price: 0.2, date_sent: date_sent - 1),
                build(:sent_buy_limit_order, price: 0.15, date_sent: date_sent)
              ] }
              it { should == [orders[2], orders[1], orders[3], orders[0]] }
            end
          end

        end # buy limit orders

        context 'sell limit orders' do
          let(:other_date_sent) { subject.date_sent }
          let(:other_price) { nil }
          let(:other) { build(:sent_sell_limit_order, price: other_price, date_sent: other_date_sent) }
          subject { build(:sent_sell_limit_order) }

          context 'when other order price is less than subject order price' do
            let(:other_price) { subject.price * 0.99 }
            it { comparison.should == 1 }
            it { inverse_comparison.should == -1 }
          end

          context 'when other order price is same as subject order price' do
            let(:other_price) { subject.price }

            context 'when other order was sent before subject order' do
              let(:other_date_sent) { subject.date_sent - 1 }
              it { comparison.should == 1 }
              it { inverse_comparison.should == -1 }
            end

            context 'when other order was sent at same time as subject order' do
              let(:other_date_sent) { subject.date_sent }
              it { comparison.should_not == 0 }
              it { inverse_comparison.should_not == 0 }
            end

            context 'when other order was sent after subject order' do
              let(:other_date_sent) { subject.date_sent + 1 }
              it { comparison.should == -1 }
              it { inverse_comparison.should == 1 }
            end

            context 'when other order is a sell limit order with same price' do
              let(:other) { build(:sent_buy_limit_order, price: other_price, date_sent: other_date_sent) }

              context 'when other orders date sent is before' do
                let(:other_date_sent) { subject.date_sent - 1 }
                it { comparison.should == 0 }
                it { inverse_comparison.should == 0 }
              end

              context 'when other orders date sent at same time' do
                let(:other_date_sent) { subject.date_sent }
                it { comparison.should == 0 }
                it { inverse_comparison.should == 0 }
              end

              context 'when other orders date sent is after' do
                let(:other_date_sent) { subject.date_sent + 1 }
                it { comparison.should == 0 }
                it { inverse_comparison.should == 0 }
              end

            end # other order is different side
          end

          context 'when other order is the same as subject order' do
            let(:other) { subject }
            it { comparison.should == 0 }
            it { inverse_comparison.should == 0 }
          end

          context 'when other order price is greater than subject order price' do
            let(:other_price) { subject.price * 1.01 }
            it { comparison.should == -1 }
            it { inverse_comparison.should == 1 }
          end

          context 'sorting in an array' do
            let(:date_sent) { Date.new }
            let(:orders) { [] }
            subject { orders.sort }

            context 'with orders not in sorted order' do
              let(:orders) { [
                build(:sent_sell_limit_order, price: 0.1, date_sent: date_sent),
                build(:sent_sell_limit_order, price: 0.2, date_sent: date_sent),
                build(:sent_sell_limit_order, price: 0.2, date_sent: date_sent - 1),
                build(:sent_sell_limit_order, price: 0.15, date_sent: date_sent)
              ] }
              it { should == [orders[0], orders[3], orders[2], orders[1]] }
            end
          end

        end # sell limit orders

      end # limit orders

    end # <=>

  end # object methods

  describe :class_methods do

    describe :get_pending_orders do
      let(:product) { create(:product) }
      let(:orders) { [] }
      subject { Order.get_pending_orders(product) }

      context 'some pending orders' do
        let(:orders) { [
          create(:pending_buy_limit_order, product: product),
          create(:pending_sell_limit_order, product: product),
          create(:sent_buy_market_order, product: product),
          create(:pending_sell_limit_order, product: product),
          create(:pending_sell_limit_order),
        ] }
        it { should == [orders[0], orders[1], orders[3]] }
      end

    end

  end

end
