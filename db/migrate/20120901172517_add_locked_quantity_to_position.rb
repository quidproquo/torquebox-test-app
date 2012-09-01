class AddLockedQuantityToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :locked_quantity, :float, default: 0.0, null: false
  end
end
