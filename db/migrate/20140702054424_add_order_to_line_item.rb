class AddOrderToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :line_items, :order, index: true
  end
end
