class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: params[:id])

    return if @order

    flash[:danger] = t "order.not_found"
    redirect_to root_path
  end

  def index
    @orders = current_user.orders
    return if @orders.present?

    flash[:danger] = t "order.nil_order"
    redirect_to root_path
  end
end
