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

end
