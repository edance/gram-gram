module BuilderHelper
  def formatted_price
    Money.new(Postcard::PRICE, 'USD').format
  end

  def month_year
    @postcard.photo.ig_timestamp.strftime('%B %Y')
  end
end
