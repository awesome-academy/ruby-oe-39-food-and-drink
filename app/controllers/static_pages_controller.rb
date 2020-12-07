class StaticPagesController < ApplicationController
  def home
    @products = Product.order_alphabet_name.page(params[:page])
                       .per(Settings.page.per_page)
  end
end
