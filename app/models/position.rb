class Position < ActiveRecord::Base
  attr_accessible :account, :product, :quantity

  # Associations:
  belongs_to :account
  belongs_to :product

  # Validations:
  validates_presence_of :account
  validates_presence_of :product


  # Methods:

  def credit(amount)
    raise ArgumentError.new("amount should be >= 0, but was: #{amount} for position: #{self}") if amount < 0
    self.quantity += amount
  end

  def debit(amount)
    raise ArgumentError.new("amount should be >= 0, but was: #{amount} for position: #{self}") if amount < 0
    raise ArgumentError.new("amount should be <= #{self.quantity}, but was: #{amount} for position: #{self}") unless can_debit?(amount)
    self.quantity -= amount
  end

  def can_debit?(amount)
    amount <= self.quantity
  end

  def lockup(amount)
    raise ArgumentError.new("amount should be >= 0, but was: #{amount} for position: #{self}") if amount < 0
    raise ArgumentError.new("amount should be <= #{self.quantity - self.locked_quantity}, but was: #{amount} for position: #{self}") unless can_lockup?(amount)
    self.locked_quantity += amount
  end

  def can_lockup?(amount)
    self.locked_quantity + amount <= self.quantity
  end
end
