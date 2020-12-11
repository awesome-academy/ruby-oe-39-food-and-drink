class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.by_created_at.page(params[:page])
                   .per(Settings.page.per_page)
  end
end
