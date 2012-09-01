require 'spec_helper'

describe Account do

  describe :initialize do

    describe :new do
      subject { Account.new }
      it { should be_an_instance_of(Account) }
    end

  end

  describe :methods do

    describe :get_position do
      let(:product) { create(:product) }
      subject { create(:account) }

      context 'when existing position' do
        let(:position) { create(:position, account: subject, product: product) }
        before do
          position
        end
        it 'then it should return the existing position' do
          subject.get_position(product).should == position
        end
      end

      context 'when non existing' do
        it 'then it should return the existing position' do
          subject.get_position(product).should_not be_nil
        end
      end

    end # get_position

  end # methods

end
