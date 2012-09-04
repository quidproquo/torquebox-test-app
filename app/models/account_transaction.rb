class AccountTransaction < ActiveRecord::Base
  attr_accessible :account_id, :cost_basis, :product_id, :quantity, :transaction_type_cd
end
