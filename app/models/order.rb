class Order < ActiveRecord::Base
  attr_accessible :account_id, :date_sent, :message, :order_type, :original_quantity, :pending_quantity,
    :price, :product_id, :quantity, :side, :status

  # Fields:
  as_enum :status, { draft: 'D', sent: 'S', rejected: 'R', open: 'O', pending: 'P', cancelled: 'C', filled: 'F' }
  as_enum :order_type, { market: 'M', limit: 'L' }
  as_enum :side, { buy: 'B', sell: 'S' }

  # Associations:
  belongs_to :product
  belongs_to :account

  # Validations:
  validates_presence_of :status
  validates_presence_of :order_type
  validates_presence_of :side
  validates_presence_of :original_quantity
  validates_presence_of :pending_quantity

  validates_presence_of :product
  validates_presence_of :account


  # Properties:

  alias_method :enum_status=, :status=

  def status=(status)
    if status == Order.statuses.sent || status == Order.statuses.sent(true)
      self.sent!
    else
      self.enum_status = status
    end
  end

  alias_method :enum_status_sent!, :sent!

  def sent!
    self.enum_status_sent!
    self.date_sent = Time.now
  end

  def price
    if self.market? and not self.attributes['price'].present?
      self.attributes['price'] = self.product.try(:price)
    else
      self.attributes['price']
    end
  end

  def quantity=(value)
    self.original_quantity = self.pending_quantity = value
  end

  def quantity
    self.original_quantity
  end

  def value
    self.price * self.quantity
  end

  # Methods:

  def reject!(message)
    rejected!
    self.message = message
  end

  # Object methods:

  def <=>(other)
    if self.market?
      date_compare(other)
    elsif self.limit?
      if (comparison = price_compare(other)) == 0
        return 0 unless self.side == other.side
        if (comparison = date_compare(other)) == 0
          id_compare(other)
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

  def id_compare(other)
    if self.id && other.id
      self.id <=> other.id
    else
      self.object_id <=> other.object_id
    end
  end

end
