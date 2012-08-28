class FixEnumColumns < ActiveRecord::Migration

  def up
    remove_column :orders, :status
    remove_column :orders, :type
    remove_column :orders, :side

    add_column :orders, :status_cd, :char, limit: 1, null: false
    add_column :orders, :order_type_cd, :char, limit: 1, null: false
    add_column :orders, :side_cd, :char, limit: 1, null: false
  end

  def down
    remove_column :orders, :status_cd
    remove_column :orders, :order_type_cd
    remove_column :orders, :side_cd

    add_column :orders, :status, :string
    add_column :orders, :type, :string
    add_column :orders, :side, :string
  end

end
