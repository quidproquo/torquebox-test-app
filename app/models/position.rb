class Position < ActiveRecord::Base

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

end
