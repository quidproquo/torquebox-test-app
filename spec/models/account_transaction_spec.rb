require 'spec_helper'

describe AccountTransaction do

  describe :new do
    it 'should new with args' do
      AccountTransaction.new(
        account_id: 1, cost_basis: 0.75, product_id: 2,
        quantity: 100, transaction_type: AccountTransaction.transaction_types.credit
      )
    end
  end

  describe :associations do
    it { should belong_to(:transactable) }
    it { should belong_to(:account) }
    it { should belong_to(:product) }
  end # associations

  describe :validation do

    describe :fields do

      describe :transaction_type do
        it { should validate_presence_of(:transaction_type) }
      end

      describe :quantity do
        it { should validate_presence_of(:quantity) }
      end

      describe :cost_basis do
        it { should validate_presence_of(:cost_basis) }
      end

    end # fields

    describe :associations do

      describe :transactable do
        it { should validate_presence_of(:transactable_id) }
      end

      describe :account do
        it { should validate_presence_of(:account_id) }
      end

      describe :product do
        it { should validate_presence_of(:product_id) }
      end

    end # associations

  end # validation

end
