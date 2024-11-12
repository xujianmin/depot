require "test_helper"

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "add a unique product to cart" do
    cart = carts(:one)
    assert_difference("cart.line_items.size", 1) do
      cart.add_product(products(:ruby))
    end
  end

  test "add duplicated product to cart" do
    cart = carts(:one)
    assert_difference("cart.line_items.size", 0) do
      cart.add_product(products(:two))
    end
  end
end
