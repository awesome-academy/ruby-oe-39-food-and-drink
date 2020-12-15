class OrdersController < ApplicationController
  include OrdersHelper
  before_action :find_order, only: %i(show update)
  before_action :logged_in_user
  before_action :load_cart_product, except: %i(show index update)

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

  def new; end

  def create
    @order = current_user.orders.new(order_params)
    ActiveRecord::Base.transaction do
      save_product_od
      @order.save!
      save_success
    end
  rescue StandardError
    flash[:danger] = t "orders.create_fail"
    render :new
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

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "orders.log_order"
    redirect_to login_path
  end

  def save_success
    session.delete :carts
    flash[:success] = t "orders.create_success"
    redirect_to user_orders_path(current_user)
  end

  def load_cart_product
    cart = current_carts
    if cart.blank?
      flash[:danger] = t "carts.nil"
      redirect_to root_path
    else
      @order = current_user.orders.new
      cart.each do |key, value|
        @product = Product.find_by(id: key)
        next unless @product

        @order.order_details.new(product: @product,
                            quantity: value, price: @product.price)
      end
    end
  end

  def save_product_od
    cart = current_carts
    cart.each do |key, value|
      @product = Product.find_by(id: key)
      next unless @product

      @order_details = @order.order_details.new(product: @product,
                          quantity: value, price: @product.price)
      @order_details.save
    end
  end

  def order_params
    params.require(:order).permit(:address, :phone_number, :delivery_time)
  end
end
