require 'spec_helper'

describe AccountTransaction do

  describe :associations do
    it { should belong_to(:transactable) }
    it { should belong_to(:account) }
    it { should belong_to(:product) }
  end # associations

  describe :validation do

    describe :transactable do
      it { should validate_presence_of(:transactable) }
    end

    describe :account do
      it { should validate_presence_of(:account) }
    end

    describe :product do
      it { should validate_presence_of(:product) }
    end

    describe :transaction_type do
      it { should validate_presence_of(:transaction_type) }
    end

    describe :quantity do
      it { should validate_presence_of(:quantity) }
    end

    describe :cost_basis do
      it { should validate_presence_of(:cost_basis) }
    end

  end # validation

end
