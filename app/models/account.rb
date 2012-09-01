class Account < ActiveRecord::Base
  # attr_accessible :title, :body

  # Methods

  def get_position(product)
    Position.find_or_create_by_account_id_and_product_id(self.id, product.id)
  end

  def get_cash_position
    get_position(Product.cash_product)
  end

end
