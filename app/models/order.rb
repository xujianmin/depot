class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items

  enum pay_type: {
    "Check" => 0,
    "Credit Card" => 1,
    "Purchase Order" => 2
  }

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item # 这行等价于 this.line_items << item，此处的 this 就是这个 Order 的当前实例。
    end
  end
end
