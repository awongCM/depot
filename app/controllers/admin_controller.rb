class AdminController < ApplicationController
  def index
    @total_orders = Order.count
  end

  def login
    if User.count.zero?
      redirect_to(:controller =>'users', :action=>'new')
    end
  end
end
