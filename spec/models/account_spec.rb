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

    describe :get_cash_position do
      let(:account) { create(:account) }

      context 'when cash product exists' do
        let(:cash_product) { create(:cash_product) }
        subject { account.get_cash_position }
        before do
          cash_product
        end

        context 'when existing cash position' do
          let(:cash_position) { create(:position, account: account, product: cash_product) }
          before do
            cash_position
          end
          it { should == cash_position }
          its('product.name') { should == 'CASH' }
        end

        context 'when position doesnt yet exist' do
          it { should_not be_nil }
          its('product.name') { should == 'CASH' }
        end

      end # existing cash product

    end # get_cash_position

  end # methods

end
