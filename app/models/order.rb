class Order < ActiveRecord::Base
  attr_accessible :account_id, :date_sent, :message, :original_quantity, :pending_quantity, :price, :product_id, :side, :status, :type

  # Associations:
  belongs_to :product
  belongs_to :account

  # Validations:
  validates_presence_of :status
  validates_presence_of :side
  validates_presence_of :price
  validates_presence_of :original_quantity
  validates_presence_of :pending_quantity

  validates_presence_of :product
  validates_presence_of :account


  # Properties
  def quantity=(value)
    self.original_quantity = self.pending_quantity = value
  end

  def quantity
    self.original_quantity
  end

end
