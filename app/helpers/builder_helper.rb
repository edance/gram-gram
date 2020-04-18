module BuilderHelper
  def formatted_price
    Money.new(@order.price_in_cents, 'USD').format
  end

  def postcard_count
    @postcard_count ||= @order.recipients.count
  end

  def default_payment_source
    id = @current_user.stripe_customer.default_source
    payment_sources.find { |x| x.id == id }
  end

  def payment_sources
    @current_user.stripe_customer.sources
  end

  def exp_date
    source = default_payment_source
    "#{source.exp_month}/#{source.exp_year}"
  end
end
