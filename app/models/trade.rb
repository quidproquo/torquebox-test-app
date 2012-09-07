class Trade < ActiveRecord::Base

  attr_accessible :buy_account, :sell_account, :product,
    :buy_order, :sell_order, :price, :quantity

  # Associations:
  belongs_to :buy_order, class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'
  belongs_to :buy_account, class_name: 'Account'
  belongs_to :sell_account, class_name: 'Account'
  belongs_to :product

  has_many :transactions, as: :transactable, class_name: 'AccountTransaction'

  # Properties:
  def value
    self.price * self.quantity
  end

  # Methods:


  # Callbacks:
  before_create :build_transactions

  def build_transactions
    # Debit cash from buy account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.debit,
      account: buy_account, product: Product.cash_product,
      cost_basis: 1, quantity: self.value)

    # Credit shares to buy account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.credit,
      account: buy_account, product: self.product,
      cost_basis: self.price, quantity: self.quantity)

    # Credit cash to buy account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.credit,
      account: sell_account, product: Product.cash_product,
      cost_basis: 1, quantity: self.value)

    # Debit shares from sell account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.debit,
      account: sell_account, product: self.product,
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

    def get_trade_price(order1, order2)
      order1.price
    end

    def get_trade_quantity(order1, order2)
      [order1.pending_quantity, order2.pending_quantity].min
    end

  end

end
