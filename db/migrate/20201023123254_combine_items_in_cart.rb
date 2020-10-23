class CombineItemsInCart < ActiveRecord::Migration[6.0]

=begin 
This is for all the created multiple line_items with the same product_id 
In this migration we sum quantities by product_id

To be able to revert the changes(?!?!!?)- rollback 
We need to find quantities larger than one and 
create multiple line_items with the same product_id and quantity of 1 
=end

  def up
    Cart.all.each do |cart|
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          cart.line_items.where(product_id: product_id).delete.all

          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  
  def down
    LineItem.where('quantity>1').each do |line_item|
      line_item.quantity.times do
        LineItem.create(cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1)
      end
      line_item.destroy
    end
  end



end