class CopiesProductPricestoItemsPriceInCart < ActiveRecord::Migration[7.2]

  def up
        say_with_time "Updating prices..." do
          LineItem.all.each do |line_item|
            line_item.price = line_item.product.price
            line_item.save!
          end
        end
  end

  def down
      LineItem.all.each do |line_item|
        line_item.price = 0
      end
  end

end
