class AddColumnsToTrade < ActiveRecord::Migration
  def change
    add_column :trades, :buy_account_id, :integer, null: false
    add_column :trades, :sell_account_id, :integer, null: false
    add_column :trades, :product_id, :integer, null: false
    add_column :trades, :buy_order_id, :integer, null: false
    add_column :trades, :sell_order_id, :integer, null: false
    remove_column :trades, :account_id
    remove_column :trades, :order_id
  end
end
