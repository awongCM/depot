class Cart < ActiveRecord::Base
    has_many :line_items

    before_destroy :delete_line_items

    def add_product(product_id, product_price)
        current_item = line_items.find_by(product_id: product_id)
        if current_item
            current_item.quantity += 1
        else
            current_item = LineItem.new(product_id: product_id, price: product_price)
            line_items << current_item
        end
        current_item
    end

    def total_price
        line_items.to_a.sum { |item| item.total_price }
    end

    private

      def delete_line_items
        LineItem.where(cart_id: id).delete_all
      end

end
