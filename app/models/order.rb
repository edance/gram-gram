class Order < ApplicationRecord
  PRICE = 295 # Price in USD cents

  belongs_to :photo

  has_one :user, through: :photo

  enum status: %i[pending processing mailed in_transit delivered]

  validates :caption, length: {
              maximum: 200,
              too_long: '200 characters is the maximum allowed'
            }


  has_and_belongs_to_many :recipients

  def price_in_cents
    PRICE * recipients.count
  end
end
