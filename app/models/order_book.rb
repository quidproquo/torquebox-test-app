class OrderBook

  attr_reader :product

  def initialize(product_id)
    @product = Product.find(product_id)
  end


  # Properties:
  
  def orders
    @orders ||= []
  end

  def buy_orders
    @buy_orders ||= []
  end

  def buy_market_orders
    @buy_market_orders ||= []
  end

  def buy_limit_orders
    @buy_limit_orders ||= []
  end

  def sell_orders
    @sell_orders ||= []
  end

  def sell_market_orders
    @sell_market_orders ||= []
  end

  def sell_limit_orders
    @sell_limit_orders ||= []
  end


  # Methods:

  def add_order(order)
    orders << order
    case order.side
    when 'buy'
      add_buy_order(order)
    when 'sell'
      add_sell_order(order)
    end
  end

  def remove_order(order)
    orders.delete(order)
    case order.side
    when 'buy'
      remove_buy_order(order)
    when 'sell'
      remove_sell_order(order)
    end
  end

  
  protected

  # Methods:

  def add_buy_order(buy_order)
    buy_orders << buy_order
    case buy_order.type
    when 'market'
      buy_market_orders << buy_order
    when 'limit'
      buy_limit_orders << buy_order
    end
  end

  def add_sell_order(sell_order)
    sell_orders << sell_order
    case sell_order.type
    when 'market'
      sell_market_orders << sell_order
    when 'limit'
      sell_limit_orders << sell_order
    end
  end

  def remove_buy_order(buy_order)
    buy_orders.delete(buy_order)
    case buy_order.type
    when 'market'
      buy_market_orders.delete(buy_order)
    when 'limit'
      buy_limit_orders.delete(buy_order)
    end
  end

  def remove_sell_order(sell_order)
    sell_orders.delete(sell_order)
    case sell_order.type
    when 'market'
      sell_market_orders.delete(sell_order)
    when 'limit'
      sell_limit_orders.delete(sell_order)
    end
  end

end
