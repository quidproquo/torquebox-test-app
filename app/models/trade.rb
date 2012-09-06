class Trade < ActiveRecord::Base

  attr_accessible :account, :order, :price, :quantity

  # Associations:
  belongs_to :buy_account, class_name: 'Account'
  belongs_to :sell_account, class_name: 'Account'
  belongs_to :product
  belongs_to :buy_order, class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'

  has_many :transactions, as: :transactable, class_name: 'AccountTransaction'


  # Class methods:
  def self.create_trade(order1, order2)
    nil
  end

  def self.create_trades(order1, order2)
    trades = [
      Trade.new(order: order1, price: order1.price, quantity: order1.quantity),
      Trade.new(order: order2, price: order1.price, quantity: order1.quantity),
    ]
    trades.each(&:save!)
    order1.status = 'filled'
    order1.save!
    order2.status = 'filled'
    order2.save!
    trades
  end


end
