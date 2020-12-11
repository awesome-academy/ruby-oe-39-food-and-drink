class CartsController < ApplicationController
  before_action :load_product, :check_quantity, only: %i(create)
  before_action :current_carts, only: %i(index create)

  def index
    @total_price = 0
    flag = false
    @order_details = Array.new
    session[:carts].each do |product_id, quantity|
      @product = Product.find_by id: product_id
      if @product
        @order_details << OrderDetail.new(product_id: @product.id,
        quantity: quantity, price: @product.price)
        @total_price += @product.price * quantity
      else
        flag = true
        session[:carts].delete(product_id)
      end
    end
    flash.now[:danger] = t "carts.product_not_found" if flag
  end

  def create
    if @carts.include?(params[:product_id])
      @carts[params[:product_id]] += params[:quantity].to_i
    else
      @carts[params[:product_id]] = params[:quantity].to_i
    end
    session[:carts] = @carts
    flash[:success] = t "carts.add_success"
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:product_id])

    flash[:danger] = t "carts.product_not_found"
    redirect_to carts_path
  end
end
