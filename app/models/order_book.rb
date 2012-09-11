require 'lib/collections/tree_set'

class OrderBook

  attr_reader :product, :orders, :buy_orders, :buy_market_orders, :buy_limit_orders,
    :sell_orders, :sell_market_orders, :sell_limit_orders

  def initialize(product, pending_orders = [])
    puts "OrderBook.initialize().start"
    @product = product
    add_orders(pending_orders)
    puts "OrderBook.initialize().end"
  end


  # Properties:

  def orders
    @orders ||= []
  end

  def buy_orders
    @buy_orders ||= []
  end

  def buy_market_orders
    @buy_market_orders ||= TreeSet.new
  end

  def buy_limit_orders
    @buy_limit_orders ||= TreeSet.new
  end

  def sell_orders
    @sell_orders ||= []
  end

  def sell_market_orders
    @sell_market_orders ||= TreeSet.new
  end

  def sell_limit_orders
    @sell_limit_orders ||= TreeSet.new
  end


  # Methods:

  def add_order(order)
    orders << order
    case order.side
    when :buy
      add_buy_order(order)
    when :sell
      add_sell_order(order)
    end
  end

  def add_orders(orders)
    orders.each { |order|
      add_order(order)
    }
  end

  def remove_order(order)
    orders.delete(order)
    case order.side
    when :buy
      remove_buy_order(order)
    when :sell
      remove_sell_order(order)
    end
  end

  def get_matching_orders(order)
    case order.order_type
    when Order.order_types.market(true)
    when Order.order_types.limit_order(true)
      case order.side
      when :buy
        get_matching_sell_limit_orders(order)
      when :sell
        get_matching_buy_limit_orders(order)
      end
    end
  end

  def get_matching_sell_limit_orders(order)
    sell_limit_orders.get_head_set(order)
  end

  def get_matching_buy_limit_orders(order)
    buy_limit_orders.get_head_set(order)
  end

  def save!
    Rails.cache.write(OrderBook.get_cache_key(self.product.id), self)
  end

  # Class methods:

  class << self

    def get_cache_key(product_id)
      {product_id_order_book: product_id}
    end

    def find_by_product_id(product_id)
      puts "Product.find(#{product_id}).start"
      product = Product.find(product_id)
      puts "Product.find(#{product_id}).end"

      puts "Order.get_pending_orders(#{product_id}).start"
      pending_orders = Order.get_pending_orders(product)
      puts "Order.get_pending_orders(#{product_id}).end"

      OrderBook.new(product, pending_orders)
    end

    def find_by_product_id_cached(product_id)
      unless order_book = Rails.cache.read(self.get_cache_key(product_id))
        order_book = self.find_by_product_id(product_id)
        Rails.cache.write(self.get_cache_key(product_id), order_book)
      end
      order_book
    end

  end

  protected

  # Methods:

  def add_buy_order(buy_order)
    buy_orders << buy_order
    case buy_order.order_type
    when Order.order_types.market(true)
      buy_market_orders << buy_order
    when Order.order_types.limit_order(true)
      buy_limit_orders << buy_order
    end
  end

  def add_sell_order(sell_order)
    sell_orders << sell_order
    case sell_order.order_type
    when Order.order_types.market(true)
      sell_market_orders << sell_order
    when Order.order_types.limit_order(true)
      sell_limit_orders << sell_order
    end
  end

  def remove_buy_order(buy_order)
    buy_orders.delete(buy_order)
    case buy_order.order_type
    when Order.order_types.market(true)
      buy_market_orders.delete(buy_order)
    when Order.order_types.limit_order(true)
      buy_limit_orders.delete(buy_order)
    end
  end

  def remove_sell_order(sell_order)
    sell_orders.delete(sell_order)
    case sell_order.order_type
    when Order.order_types.market(true)
      sell_market_orders.delete(sell_order)
    when Order.order_types.limit_order(true)
      sell_limit_orders.delete(sell_order)
    end
  end

end
