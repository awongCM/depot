class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :payment_type

  #PAYMENT_TYPES = ["Check", "Credit card", "Purchase order"]

  validates :name, :address, :email, presence: true
  validates :payment_type_id, presence: true

  before_destroy :delete_line_items

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
        item.cart_id=nil
        line_items << item
    end
  end

  private

    def delete_line_items
      LineItem.where(order_id: id).delete_all
    end
end
