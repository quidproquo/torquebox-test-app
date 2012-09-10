class Product < ActiveRecord::Base

  # Constants:
  CASH_PRODUCT_KEY = 'cash_product'

  # Fields:
  attr_accessible :name, :price

  # Class methods:
  class << self

    def cash_product
      unless cash_product = Rails.cache.read(CASH_PRODUCT_KEY)
        cash_product = Product.find_or_create_by_name('CASH')
        Rails.cache.write(CASH_PRODUCT_KEY, cash_product)
      end
      cash_product
    end

  end

end
