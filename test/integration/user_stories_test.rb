require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :all

  def setup
    # Public storefront flows should not require admin login.
    ActionMailer::Base.deliveries.clear
  end

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])

    assert_equal 1, LineItem.where(cart_id: cart.id).count
    assert_equal ruby_book, cart.line_items.first.product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
    order: { name: "Dave Thomas",
     address: "123 The Street",
     email: "dave@example.com",
     payment_type_id: payment_types(:one).id
   }

   assert_response :success
   assert_template "index"
   cart = Cart.find(session[:cart_id])
   assert_equal 0, cart.line_items.count

   orders = Order.all
   assert_equal 1, orders.size
   order = orders[0]

   assert_equal "Dave Thomas", order.name
   assert_equal "123 The Street", order.address
   assert_equal "dave@example.com", order.email
   assert_equal payment_types(:one).id, order.payment_type_id
   assert_nil order.ship_date

   assert_equal 1, LineItem.where(order_id: order.id).count
   line_item = order.line_items.first
   assert_equal ruby_book, line_item.product

   mail = ActionMailer::Base.deliveries.last
   assert_equal ["dave@example.com"], mail.to
   assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
   assert_equal 'Pragmatic Store Order Confirmation', mail.subject
 end

  test "should mail the sys admin when error occurs" do
    ActionMailer::Base.deliveries.clear

    get "/carts/eee"
    assert_response 302
    assert_redirected_to store_path(locale: 'en')

    mail = ActionMailer::Base.deliveries.last

    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Depot App Error Incident', mail.subject
 end

end
