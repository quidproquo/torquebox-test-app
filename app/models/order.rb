class Order < ActiveRecord::Base
  attr_accessible :account_id, :date_sent, :message, :original_quantity, :pending_quantity, :price, :product_id, :side, :status, :type

  # Associations:
  belongs_to :product
  belongs_to :account

  # Misc mappings:
  self.inheritance_column = :ruby_type

  # Validations:
  validates_presence_of :status
  validates_presence_of :type
  validates_presence_of :side
  validates_presence_of :price
  validates_presence_of :original_quantity
  validates_presence_of :pending_quantity

  validates_presence_of :product
  validates_presence_of :account


  # Properties:

  def quantity=(value)
    self.original_quantity = self.pending_quantity = value
  end

  def quantity
    self.original_quantity
  end


  # Object methods:

  def <=>(other)
    case other.type
    when 'market'
      -(self.date_sent <=> other.date_sent)
    when 'limit'
      if (price_compare = self.price <=> other.price) == 0
        if (date_compare = -(self.date_sent <=> other.date_sent)) == 0
          self.id <=> other.id
        else
          date_compare
        end
      else
        price_compare
      end
    end
  end

end
