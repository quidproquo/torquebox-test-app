# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :account_transaction do
    transaction_type { AccountTransaction.transaction_types.credit }
    quantity { 1000 }
    cost_basis { 1 }
    association :transactable, factory: :trade
    association :account
    association :product

    factory :credit_transaction do
      transaction_type { AccountTransaction.transaction_types.credit }
    end

    factory :debit_transaction do
      transaction_type { AccountTransaction.transaction_types.debit }
    end

  end

end
