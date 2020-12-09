class OrdersController < ApplicationController
  include OrdersHelper
  before_action :find_order, only: %i(show update)

  def show; end

  def index
    @orders = current_user.orders
    return if @orders.present?

    flash[:danger] = t "order.nil_order"
    redirect_to root_path
  end

  def update
    status = params[:status].to_i
    if status == Order.statuses[:delivered]
      deliver_order
    elsif status == Order.statuses[:canceled]
      cancel_order
    else
      flash[:danger] = t "order.status_error"
    end
    redirect_to user_orders_path
  rescue StandardError
    flash[:danger] = t "order.status_fail"
    redirect_to user_orders_path
  end

  private

  def find_order
    @order = current_user.orders.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order.nil_order"
    redirect_to user_orders_path
  end

  def cancel_order
    if @order.accepted?
      Order.transaction do
        @order.cancel
        flash[:success] = t "order.status_success"
      end
    else
      flash[:danger] = t "order.status_error"
    end
  end

  def deliver_order
    if @order.shipping?
      @order.delivered!
      flash[:success] = t "order.status_success"
    else
      flash[:danger] = t "order.status_error"
    end
  end
end
