class Trade < ActiveRecord::Base

  attr_accessible :buy_account_id, :sell_account_id, :product_id,
    :buy_order, :sell_order, :price, :quantity

  # Associations:
  belongs_to :buy_order, class_name: 'Order'
  belongs_to :sell_order, class_name: 'Order'
  belongs_to :buy_account, class_name: 'Account'
  belongs_to :sell_account, class_name: 'Account'
  belongs_to :product

  has_many :transactions, as: :transactable, class_name: 'AccountTransaction'

  # Validation:
  validates_presence_of :price
  validates_presence_of :quantity
  validates_presence_of :buy_order_id
  validates_presence_of :sell_order_id
  validates_presence_of :buy_account_id
  validates_presence_of :sell_account_id
  validates_presence_of :product_id

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
      account_id: self.buy_account_id, product_id: Product.cash_product.id,
      cost_basis: 1, quantity: self.value)

    # Credit shares to buy account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.credit,
      account_id: self.buy_account_id, product_id: self.product_id,
      cost_basis: self.price, quantity: self.quantity)

    # Credit cash to buy account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.credit,
      account_id: self.sell_account_id, product_id: Product.cash_product.id,
      cost_basis: 1, quantity: self.value)

    # Debit shares from sell account
    self.transactions.build(transaction_type: AccountTransaction.transaction_types.debit,
      account_id: self.sell_account_id, product_id: self.product_id,
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
      quantity = get_trade_quantity(order1, order2)
      order1.fill_quantity(quantity)
      order2.fill_quantity(quantity)
      Trade.create(buy_account_id: buy_order.account_id, sell_account_id: sell_order.account_id,
        product_id: buy_order.product_id, buy_order: buy_order, sell_order: sell_order,
        price: get_trade_price(order1, order2),
        quantity: quantity)
    end

    def get_trade_price(order1, order2)
      order1.price
    end

    def get_trade_quantity(order1, order2)
      [order1.pending_quantity, order2.pending_quantity].min
    end

  end

end
