class Trade < ActiveRecord::Base
  attr_accessible :account_id, :order_id, :price, :quantity
end
