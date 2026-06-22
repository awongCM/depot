require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  test "total_price uses snapshotted price, not current product price" do
    product = products(:ruby)
    line_item = LineItem.new(product: product, quantity: 2, price: 10.00)

    product.price = 99.99

    assert_equal 20.00, line_item.total_price
  end

  test "decrement_quantity destroys item when quantity reaches zero" do
    line_item = line_items(:two)
    line_item.update!(quantity: 1)

    line_item.decrement_quantity

    assert_raises(ActiveRecord::RecordNotFound) { line_item.reload }
  end
end
