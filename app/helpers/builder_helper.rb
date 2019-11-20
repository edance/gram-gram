module BuilderHelper
  def formatted_price
    Money.new(Postcard::PRICE, 'USD').format
  end
end
