class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :quantity, default: 0.0, null: false
      t.integer :account_id, null: false
      t.integer :product_id, null: false

      t.timestamps
    end
  end
end
