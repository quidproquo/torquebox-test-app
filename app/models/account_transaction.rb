class AccountTransaction < ActiveRecord::Base
  attr_accessible :account, :cost_basis, :product, :quantity, :transaction_type

  # Fields:
  as_enum :transaction_type, {debit: 'D', credit: 'C'}

  # Associations:
  belongs_to :transactable, polymorphic: true
  belongs_to :account
  belongs_to :product

  # Validation:
  validates_presence_of :transactable
  validates_presence_of :account
  validates_presence_of :product
  validates_presence_of :transaction_type
  validates_presence_of :quantity
  validates_presence_of :cost_basis



end
