#!/usr/bin/env ruby
# Cloud Agent only — smoke-test a running dev server at http://127.0.0.1:3000
# Exercises the storefront over real HTTP (with CSRF), separate from the test DB.
require "net/http"
require "uri"
require "cgi"

BASE = URI("http://127.0.0.1:3000")

def http
  @http ||= begin
    h = Net::HTTP.new(BASE.host, BASE.port)
    h.read_timeout = 30
    h
  end
end

def cookies
  @cookies ||= {}
end

def cookie_header
  cookies.map { |k, v| "#{k}=#{v}" }.join("; ")
end

def store_cookies(response)
  (response.get_fields("set-cookie") || []).each do |raw|
    name, value = raw.split(";").first.split("=", 2)
    cookies[name] = value
  end
end

def get(path)
  uri = URI.join(BASE, path)
  req = Net::HTTP::Get.new(uri)
  req["Cookie"] = cookie_header unless cookies.empty?
  res = http.request(req)
  store_cookies(res)
  raise "GET #{path} failed: #{res.code}" unless res.code.to_i.between?(200, 399)
  res
end

def post(path, params)
  uri = URI.join(BASE, path)
  req = Net::HTTP::Post.new(uri)
  req["Cookie"] = cookie_header unless cookies.empty?
  req.set_form_data(params)
  res = http.request(req)
  store_cookies(res)
  res
end

def csrf_token(html)
  html[/content="([^"]+)"\s+name="csrf-token"/, 1] ||
    html[/name="csrf-token"\s+content="([^"]+)"/, 1] ||
    html[/name="authenticity_token" type="hidden" value="([^"]+)"/, 1] ||
    raise("CSRF token not found")
end

def first_line_item_form(html)
  html[/action="(\/line_items[^"]+)"[^>]*method="post"/, 1]
end

def product_id(html)
  html[/line_items\?[^"']*product_id=(\d+)/, 1] ||
    html[/product_id=(\d+)/, 1] ||
    raise("product_id not found on storefront")
end

puts "==> [live smoke] GET /"
home = get("/")
raise "Storefront missing products" unless home.body.include?("Programming Ruby") || home.body.include?("CoffeeScript")

puts "==> [live smoke] POST /line_items (add to cart)"
path = first_line_item_form(home.body)
path = path.gsub("&amp;", "&") if path
raise "Add to cart form not found" unless path
token = csrf_token(home.body)
cart_res = post(path, authenticity_token: token)
raise "Add to cart failed: #{cart_res.code}" unless cart_res.code.to_i.between?(200, 399)

puts "==> [live smoke] GET /orders/new"
order_form = get("/orders/new")
token = csrf_token(order_form.body)

puts "==> [live smoke] POST /orders (checkout)"
checkout = post("/orders?locale=en", {
  "order[name]" => "Cloud Agent Smoke",
  "order[address]" => "123 Test Street",
  "order[email]" => "smoke@example.com",
  "order[payment_type_id]" => "1",
  "authenticity_token" => token
})
raise "Checkout failed: #{checkout.code}" unless checkout.code.to_i.between?(200, 399)
raise "Checkout did not redirect to store" unless checkout.code == "302" || checkout.body.include?("Pragmatic")

puts "==> [live smoke] All live HTTP checks passed."
