# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

User.create(email: 'admin@test.com', password: 'admin123' )

Account.create()
Account.create()

Product.create()
Product.cash_product.update_attributes(price: 1)

Account.all.each { |account|
  Product.all.each { |product|
    Position.create(account: account, product: product, quantity: 1000000)
  }
}

