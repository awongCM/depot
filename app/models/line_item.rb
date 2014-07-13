class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def decrement_quantity
      self.decrement!(:quantity, 1)
      if self.quantity == 0
        self.destroy
      end
  end

end
