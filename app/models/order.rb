class Order < ApplicationRecord
  PRICE = 295 # Price in USD cents

  belongs_to :photo
  has_one :user, through: :photo
  has_many :postcard_receipts
  has_and_belongs_to_many :recipients

  enum status: %i[pending completed]

  validates :caption, length: {
              maximum: 200,
              too_long: '200 characters is the maximum allowed'
            }


  after_commit :send_with_lob_if_sendable
  after_commit :send_receipt, if: :completed?

  def photo_url
    photo.ig_media_url
  end

  def price_in_cents
    PRICE * recipients.count
  end

  def lob_description
    "order_#{id}"
  end

  def paid?
    stripe_charge && stripe_charge['paid']
  end

  def stripe_charge
    return nil if stripe_charge_id.nil?

    @stripe_charge = Stripe::Charge.retrieve(stripe_charge_id)
  end

  def send_receipt
    OrderMailer.with(order: self).receipt.deliver_later
  end

  private

  def send_with_lob_if_sendable
    SendOrderJob.perform_later(self) if sendable?
  end

  def sendable?
    !recipients.empty? &&
      photo.present? &&
      stripe_charge_id.present?
  end
end
