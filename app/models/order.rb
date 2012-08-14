class Order < ActiveRecord::Base
  attr_accessible :account_id, :date_sent, :message, :original_quantity, :pending_quantity, :price, :product_id, :side, :status, :type

end
