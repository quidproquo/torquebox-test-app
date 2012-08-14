require 'spec_helper'

describe ProdOrdMessageProcessor do

  subject { ProdOrdMessageProcessor.new }

  describe :initialize do
  
    describe :new do
      subject { ProdOrdMessageProcessor.new }
      it { should be_an_instance_of(ProdOrdMessageProcessor) }
    end

  end #initialize

  describe :methods do

    describe :on_message do

      context :buy_order_message do
        let(:message) { create(:order) }
        it 'should process the message' do
          subject.on_message(message)
          true.should == true
        end

      end

    end

  end

end
