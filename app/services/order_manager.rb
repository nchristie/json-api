class OrderManager

  def self.user_cancel(order, cancellation_reason)
    order.transaction do
      order.reload(lock: true)
      order.cancellation_reason = cancellation_reason
      order.cancel_order
    end
    return true
  end
end