class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :side
      t.string :type
      t.float :price
      t.integer :original_quantity
      t.integer :pending_quantity
      t.string :message
      t.timestamp :date_sent
      t.integer :account_id
      t.integer :product_id

      t.timestamps
    end
  end
end
