module OrdersHelper
  def cal_total_order order
    @total = 0
    order_details = order.order_details
    @total = order_details.reduce(0) do |sum, o|
      sum + o.quantity * o.price
    end
    return @total - order.voucher.discount if order.voucher

    @total
  end

  def check_voucher? order
    order.voucher
  end

  def cal_old_total
    @total
  end
end
