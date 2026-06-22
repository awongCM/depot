require 'test_helper'

class PaymentTypeTest < ActiveSupport::TestCase
  test "has many orders" do
    payment_type = payment_types(:one)
    assert_includes payment_type.orders, orders(:one)
  end

  test "names returns all payment type names" do
    names = PaymentType.names
    assert_includes names, payment_types(:one).name
    assert_includes names, payment_types(:two).name
  end
end
