class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  def total_price
    price * quantity
  end

  def decrement_quantity
      self.decrement!(:quantity, 1)
      if self.quantity == 0
        self.destroy
      end
  end

end
