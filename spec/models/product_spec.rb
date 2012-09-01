require 'spec_helper'

describe Product do

  describe :class_methods do
    subject { Product }

    describe :cash_product do
      subject { Product.cash_product }

      context 'when cash product already exists' do
        let(:cash_product) { create(:cash_product) }
        before do
          cash_product
        end
        it { should == cash_product }
      end

      context 'when cash product doesnt already exist' do
        it { should_not be_nil }
        its(:name) { should == 'CASH' }
      end

    end

  end

end
