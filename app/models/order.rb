class Order < ActiveRecord::Base
  #attr_accessible :account_id, :date_sent, :message, :original_quantity, :pending_quantity, :price, :product_id, :side, :status, :type

  # Fields:
  as_enum :status, { draft: 'D', open: 'O', sent: 'S', pending: 'P', filled: 'F' }
  as_enum :order_type, { market: 'M', limit: 'L' }
  as_enum :side, { buy: 'B', sell: 'S' }

  # Associations:
  belongs_to :product
  belongs_to :account

  # Validations:
  validates_presence_of :status
  validates_presence_of :order_type
  validates_presence_of :side
  validates_presence_of :price
  validates_presence_of :original_quantity
  validates_presence_of :pending_quantity

  validates_presence_of :product
  validates_presence_of :account


  # Properties:

  alias_method :enum_status=, :status=
  alias_method :enum_status_sent!, :sent!

  def status=(status)
    if status == Order.statuses.sent || status == Order.statuses.sent(true)
      self.date_sent = Time.now
    end
    self.enum_status = status
  end

  def sent!
    self.status = Order.statuses.sent
  end

  def quantity=(value)
    self.original_quantity = self.pending_quantity = value
  end

  def quantity
    self.original_quantity
  end


  # Object methods:

  def <=>(other)
    if self.market?
      date_compare(other)
    elsif self.limit?
      if (comparison = price_compare(other)) == 0
        return 0 unless self.side == other.side
        if (comparison = date_compare(other)) == 0
          self.id <=> other.id
        else
          comparison
        end
      else
        comparison
      end
    end
  end


  # Class methods:

  def self.get_pending_orders(product)
    Order.where(product_id: product.id, status_cd: Order.pending)
  end


  private

  def date_compare(other)
    raise ArgumentError, 'date_sent is null' unless self.date_sent
    raise ArgumentError, 'date_sent is null' unless other.date_sent
    self.date_sent <=> other.date_sent
  end


  def price_compare(other)
    raise ArgumentError, 'price is null' unless self.price
    raise ArgumentError, 'price is null' unless other.price
    (self.price <=> other.price) * (self.buy? ? -1 : 1)
  end

end
