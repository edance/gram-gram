module BuilderHelper
  def formatted_price
    Money.new(Postcard::PRICE, 'USD').format
  end

  def month_year
    @postcard.photo.ig_timestamp.strftime('%B %Y')
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
