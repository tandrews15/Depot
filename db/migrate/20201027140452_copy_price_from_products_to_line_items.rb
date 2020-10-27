class CopyPriceFromProductsToLineItems < ActiveRecord::Migration[6.0]

  def up
    Product.all.each do |product|
        LineItem.all.each do |line_item|

          if(product.id == line_item.product_id)
            line_item.price = product.price
            line_item.save!
          end
        end
      end
  end

end