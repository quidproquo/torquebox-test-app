class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :account_id
      t.integer :order_id
      t.float :price
      t.float :quantity

      t.timestamps
    end
  end
end
