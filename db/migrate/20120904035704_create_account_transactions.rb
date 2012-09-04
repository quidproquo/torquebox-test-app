class CreateAccountTransactions < ActiveRecord::Migration
  def change
    create_table :account_transactions do |t|
      t.references :transactable, polymorphic: true
      t.references :account, null: false
      t.references :product, null: false
      t.column :transaction_type_cd, :char, limit: 1, null: false
      t.float :quantity, null: false
      t.float :cost_basis, null: false

      t.timestamps
    end
  end
end
