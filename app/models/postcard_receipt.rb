class PostcardReceipt < ApplicationRecord
  belongs_to :order
  belongs_to :recipient
  has_one :photo, through: :order

  enum status: %i[pending processing mailed in_transit delivered]

  def send_postcard!
    return unless pending?

    lob_card = send_lob_postcard
    address = recipient.address

    opts = {
      **address.except(:name),
      address_name: address[:name],
      lob_id: lob_card['id'],
      status: :processing
    }

    update!(opts)
  end

  private

  def send_lob_postcard
    lob.postcards.create(
      description: order.lob_description,
      to: recipient.address,
      front: front_html,
      back: back_html
    )
  end

  def lob
    @lob ||= Lob::Client.new(
      api_key: ENV['LOB_SECRET_API_KEY'],
      api_version: '2020-02-11'
    )
  end

  def locals
    {
      :@order => order
    }
  end

  def front_html
    controller.render_to_string('postcard_template/front2', locals: locals)
  end

  def back_html
    controller.render_to_string('postcard_template/back2', locals: locals)
  end

  def controller
    @controller ||= ActionController::Base.new
  end
end
