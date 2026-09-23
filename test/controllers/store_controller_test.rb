require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', minimum: 4
    assert_select '#main .entry', 3
    assert_select 'h3', 'Programming Ruby 1.9'
    assert_select '.price', /\$[, \d]+\.\d\d/
  end

  test "changing locale posts to the store and redirects" do
    post :index, params: { set_locale: "es" }
    assert_redirected_to store_url(locale: "es")
  end

  test "markup needed for store add-to-cart buttons is in place" do
    get :index
    assert_select '.store .entry > img', 3
    assert_select '.entry[data-controller="add-to-cart"]', 3
    assert_select '.entry img[data-action="click->add-to-cart#add"]', 3
    assert_select ".entry button[type=submit]", 3
    assert_select '.entry form[data-turbo="false"]', 3
  end

end
