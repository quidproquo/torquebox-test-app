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

  describe :validation do

    context :fields do
    
      context :status do
        
        context :nil do
          subject { build(:order, status: nil) }
          it { should_not be_valid }
        end
        
        context :blank do
          subject { build(:order, status: '') }
          it { should_not be_valid }
        end
        
      end # status
    
      context :type do
        
        context :nil do
          subject { build(:order, type: nil) }
          it { should_not be_valid }
        end
        
        context :blank do
          subject { build(:order, type: '') }
          it { should_not be_valid }
        end
        
      end # type
    
      context :side do
        
        context :nil do
          subject { build(:order, side: nil) }
          it { should_not be_valid }
        end
        
        context :blank do
          subject { build(:order, side: '') }
          it { should_not be_valid }
        end
        
      end # side
    
      context :price do
        
        context :nil do
          subject { build(:order, price: nil) }
          it { should_not be_valid }
        end
        
      end # price
    
      context :original_quantity do
        
        context :nil do
          subject { build(:order, original_quantity: nil) }
          it { should_not be_valid }
        end
        
      end # original_quantity
    
      context :pending_quantity do
        
        context :nil do
          subject { build(:order, pending_quantity: nil) }
          it { should_not be_valid }
        end
        
      end # pending_quantity

    end # fields

    context :associations do
    
      context :product do
        
        context :nil do
          subject { build(:order, product: nil) }
          it { should_not be_valid }
        end

      end
      
      context :account do
        
        context :nil do
          subject { build(:order, account: nil) }
          it { should_not be_valid }
        end

      end

    end # associations

  end # validation

  describe :crud do

    describe :save do
      it 'should save and get from db' do
        order = create(:buy_market_order)
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
          let(:other) { create(:sent_buy_market_order, date_sent: other_date_sent) }
          subject { create(:sent_buy_market_order) }

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
          let(:other) { create(:sent_sell_market_order, date_sent: other_date_sent) }
          subject { create(:sent_sell_market_order) }

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
          let(:other) { create(:sent_buy_limit_order, price: other_price, date_sent: other_date_sent) }
          subject { create(:sent_buy_limit_order) }

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
              let(:other) { create(:sent_sell_limit_order, price: other_price, date_sent: other_date_sent) }

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
                create(:sent_buy_limit_order, price: 0.1, date_sent: date_sent),
                create(:sent_buy_limit_order, price: 0.2, date_sent: date_sent),
                create(:sent_buy_limit_order, price: 0.2, date_sent: date_sent - 1),
                create(:sent_buy_limit_order, price: 0.15, date_sent: date_sent)
              ] }
              it { should == [orders[2], orders[1], orders[3], orders[0]] }
            end
          end

        end # buy limit orders

        context 'sell limit orders' do
          let(:other_date_sent) { subject.date_sent }
          let(:other_price) { nil }
          let(:other) { create(:sent_sell_limit_order, price: other_price, date_sent: other_date_sent) }
          subject { create(:sent_sell_limit_order) }

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
              let(:other) { create(:sent_buy_limit_order, price: other_price, date_sent: other_date_sent) }

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
                create(:sent_sell_limit_order, price: 0.1, date_sent: date_sent),
                create(:sent_sell_limit_order, price: 0.2, date_sent: date_sent),
                create(:sent_sell_limit_order, price: 0.2, date_sent: date_sent - 1),
                create(:sent_sell_limit_order, price: 0.15, date_sent: date_sent)
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
