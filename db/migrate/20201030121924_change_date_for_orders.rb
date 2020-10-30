class ChangeDateForOrders < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :ship_date, :datetime
  end
end
