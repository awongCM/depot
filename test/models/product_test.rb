require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    assert product.errors[:locale].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
      description: "yyy",
      image_url: "zzz.jpg",
      locale: "en")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "My Book Title",
      description: "yyy",
      price: 1,
      locale: "en",
      image_url: image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "cannot destroy product referenced by line items" do
    product = products(:ruby)
    assert product.line_items.any?

    refute product.destroy
    assert Product.exists?(product.id)
    assert_includes product.errors[:base], "Line Items present"
  end

  test "can destroy product with no line items" do
    product = products(:one)
    assert product.line_items.empty?

    assert product.destroy
    refute Product.exists?(product.id)
  end

end
