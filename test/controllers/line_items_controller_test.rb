require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      #post line_items_url, params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }
      post line_items_url, params: { product_id: products(:ruby).id }
    end
    follow_redirect!

    assert_select 'h2', 'Your Cart'
    assert_select 'td', "Programming Ruby 14"
  end


  test "should create line_item via AJAX" do
    assert_difference('LineItem.count') do
      #post line_items_url, params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }
      post line_items_url, params: { product_id: products(:ruby).id, xhr: true }
    end
    assert_redirected_to store_index_url
    #assert_response :success
    assert_match /<tr class=\\"line-item-highlight"/, @response.body

  end


  test "cart count should remain the same for duplicates" do
    assert_difference('LineItem.count', 1) do
      #post line_items_url, params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }
      post line_items_url, params: { product_id: products(:ruby).id }
      post line_items_url, params: { product_id: products(:ruby).id }
    end
    follow_redirect!
    assert_select 'h2', 'Your Cart'
    assert_select 'td', "Programming Ruby 14"
  end

  test "cart count should increment" do
    assert_difference('LineItem.count', 2) do
      #post line_items_url, params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }
      post line_items_url, params: { product_id: products(:ruby).id }
      post line_items_url, params: { product_id: products(:two).id }
    end
    follow_redirect!
    assert_select 'h2', 'Your Cart'
    assert_select 'td', "Programming Ruby 14"
    assert_select 'td', "MyString2"
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    #user can only see his own cart
    #patch line_item_url(@line_item), params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }

    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item in cart" do
    post line_items_url, params: { product_id: products(:ruby).id }
    @line_item = LineItem.where(cart_id: session[:cart_id], product_id: products(:ruby).id).last
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end
    assert_redirected_to cart_url
  end
end
