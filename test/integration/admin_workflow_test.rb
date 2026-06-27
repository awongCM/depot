require 'test_helper'

class AdminWorkflowTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "admin can log in, view dashboard and orders, then log out" do
    get login_path(locale: "en")
    assert_response :success

    post login_path(locale: "en"), name: users(:one).name, password: "secret"
    assert_redirected_to admin_path(locale: "en")
    follow_redirect!
    assert_response :success

    get orders_path(locale: "en")
    assert_response :success
    assert_select "td", text: orders(:one).name

    delete logout_path(locale: "en")
    assert_redirected_to store_path(locale: "en")
  end

  test "invalid login is rejected" do
    post login_path(locale: "en"), name: users(:one).name, password: "wrong"
    assert_redirected_to login_path(locale: "en")
    follow_redirect!
    assert_equal "Invalid user/password combination", flash[:alert]
  end
end
