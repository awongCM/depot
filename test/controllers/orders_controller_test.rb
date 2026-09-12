require "test_helper"

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "requires item in cart" do
    get :new
    assert_redirected_to store_path
    assert_equal flash[:notice], "Your cart is empty"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    item = LineItem.new(product: products(:ruby), price: products(:ruby).price, quantity: 1)
    item.build_cart
    item.save!
    session[:cart_id] = item.cart.id
    get :new
    assert_response :success
  end

  test "should create order" do
    item = LineItem.new(product: products(:ruby), price: products(:ruby).price, quantity: 1)
    item.build_cart
    item.save!
    session[:cart_id] = item.cart.id

    assert_difference("Order.count") do
      post :create, params: {
        order: {
          address: @order.address,
          email: @order.email,
          name: @order.name,
          payment_type_id: @order.payment_type_id
        }
      }
    end

    assert_redirected_to store_path
  end

  test "invalid create re-renders new as unprocessable entity" do
    item = LineItem.new(product: products(:ruby), price: products(:ruby).price, quantity: 1)
    item.build_cart
    item.save!
    session[:cart_id] = item.cart.id

    post :create, params: {
      order: { name: "", address: "", email: "", payment_type_id: "" }
    }

    assert_response :unprocessable_entity
    assert_template :new
  end

  test "should show order" do
    get :show, params: { id: @order }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @order }
    assert_response :success
  end

  test "should update order" do
    patch :update, params: {
      id: @order,
      order: {
        address: @order.address,
        email: @order.email,
        name: @order.name,
        payment_type_id: @order.payment_type_id
      }
    }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete :destroy, params: { id: @order }
    end

    assert_redirected_to orders_path
  end
end
