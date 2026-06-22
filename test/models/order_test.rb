require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "requires name, address, email, and payment type" do
    order = Order.new
    assert order.invalid?
    assert order.errors[:name].any?
    assert order.errors[:address].any?
    assert order.errors[:email].any?
    assert order.errors[:payment_type_id].any?
  end

  test "belongs to payment type" do
    order = orders(:one)
    assert_equal payment_types(:one), order.payment_type
  end

  test "add_line_items_from_cart moves items from cart to order" do
    cart = Cart.create!
    product = products(:ruby)
    cart.line_items.create!(product: product, quantity: 2, price: product.price)

    order = Order.new(
      name: "Dave Thomas",
      address: "123 The Street",
      email: "dave@example.com",
      payment_type_id: payment_types(:one).id
    )
    order.add_line_items_from_cart(cart)

    assert_equal 1, order.line_items.size
    assert_nil order.line_items.first.cart_id
    assert_equal product, order.line_items.first.product
  end
end
