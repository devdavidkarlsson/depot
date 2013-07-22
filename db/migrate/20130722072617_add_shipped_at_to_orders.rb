class AddShippedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipped_at, :datetime
    add_column :orders, :shipping_status, :text
  end
end
