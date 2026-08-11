require "test_helper"

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post :create, params: { product_id: products(:ruby).id }
    end

    assert_redirected_to store_path
  end

  test "should create line_item via ajax" do
    assert_difference("LineItem.count") do
      post :create, params: { product_id: products(:ruby).id }, xhr: true
    end

    assert_response :success
    assert_match(/current_item/, @response.body)
  end

  test "should show line_item" do
    get :show, params: { id: @line_item }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @line_item }
    assert_response :success
  end

  test "should update line_item" do
    patch :update, params: {
      id: @line_item,
      line_item: { product_id: @line_item.product_id }
    }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    line_item = line_items(:two)
    session[:cart_id] = line_item.cart_id

    assert_difference("LineItem.count", -1) do
      delete :destroy, params: { id: line_item }
    end

    assert_redirected_to cart_path(session[:cart_id])
  end
end
