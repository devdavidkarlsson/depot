class AddDateAvailableToProduct < ActiveRecord::Migration
  def change
    add_column :products, :date_available, :datetime
  end
end
