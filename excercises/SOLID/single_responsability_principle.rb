class OrderProcessor
  def initialize(orders)
    @orders = orders
  end

  def process
    @orders.each do |order|
      next if order.processed?

      CommissionGenerator.new(order: order).create_commision
      OrderNotifierProcessor.new(order: order).send_email
      order.processed = true
      order.save!
    end
  end
end

class CommissionGenerator
  def initialize(order:)
    @order = order
  end

  def create_commision
    return unless @order.has_sales_rep?

    Commision.create(order: @order, amount: calculate_commision)
  end

  private

  def calculate_commision
    @order.dollar_amount * 0.03
  end
end

class OrderNotifierProcessor
  def initialize(order:)
    @order = order
  end

  def send_email
    notify_user
    notify_sales_rep
  end

  private

  def notify_user
    OrderNotifierEmail.notify_user(@order).delivery_later
  end

  def notify_sales_rep
    return unless @order.has_sales_rep?

    OrderNotifierEmail.notify_sales_rep(@order).delivery_later
  end
end
