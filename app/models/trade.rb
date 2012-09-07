class Trade < ActiveRecord::Base

  attr_accessible :buy_account, :sell_account, :product,
    :buy_order, :sell_order, :price, :quantity

  # Associations:
  belongs_to :buy_account, class_name: 'Account'
  belongs_to :sell_account, class_name: 'Account'
  belongs_to :product
  belongs_to :buy_order, class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'

  has_many :transactions, as: :transactable, class_name: 'AccountTransaction'

  # Methods:


  # Callbacks:
  before_create :build_transactions

  def build_transactions
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.debit,
      account: buy_account, product: Product.cash_product,
      cost_basis: self.price, quantity: self.quantity)
  end


  # Class methods:

  class << self

    def create_trade(order1, order2)
      if order1.buy?
        buy_order = order1
        sell_order = order2
      else
        buy_order = order2
        sell_order = order1
      end
      Trade.create(buy_account: buy_order.account, sell_account: sell_order.account,
        product: buy_order.product, buy_order: buy_order, sell_order: sell_order,
        price: get_trade_price(order1, order2),
        quantity: get_trade_quantity(order1, order2))
    end

    def create_trades(order1, order2)
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

    def get_trade_price(order1, order2)
      order1.price
    end

    def get_trade_quantity(order1, order2)
      [order1.pending_quantity, order2.pending_quantity].min
    end

  end

end
