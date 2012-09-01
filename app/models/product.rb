class Product < ActiveRecord::Base
  attr_accessible :name, :price

  # Class methods:
  class << self

    def cash_product
      Product.find_or_create_by_name('CASH')
    end

  end

end
