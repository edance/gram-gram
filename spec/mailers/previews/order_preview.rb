# Preview all emails at http://localhost:3000/rails/mailers/order
class OrderPreview < ActionMailer::Preview
  def receipt
    OrderMailer.with(order: order).receipt
  end

  private

  def order
    @order ||= Order.order(:created_at).last
  end
end
