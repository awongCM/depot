require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "cart should create a new line when adding a unique product" do
    cart = Cart.create

    cart.line_items.create(product_id: products(:ruby).id)

    cart.line_items.create(product_id: products(:one).id)

    assert_not_equal cart.line_items.first.product_id, cart.line_items.last.product_id


  end

  test "cart should create a new line when adding a non-unique product" do
    cart = Cart.create

    cart.line_items.create(product_id: products(:ruby).id)

    cart.line_items.create(product_id: products(:ruby).id)

    assert_equal cart.line_items.first.product_id, cart.line_items.last.product_id

  end

end
