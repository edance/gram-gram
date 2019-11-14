class SendPostcardJob < ApplicationJob
  queue_as :default

  attr_accessor :postcard

  def perform(postcard)
    @postcard = postcard
    return if postcard.nil?

    return unless stripe_charge_successful?

    lob.postcards.create(
      description: postcard.lob_description,
      to: postcard.recipient.address,
      front: ENV['POSTCARD_FRONT_TEMPLATE_ID'],
      back: ENV['POSTCARD_BACK_TEMPLATE_ID'],
      merge_variables: merge_variables
    )
  end

  def merge_variables
    {
      photo_url: postcard.photo.ig_permalink,
      caption: postcard.caption
    }
  end

  def stripe_charge_successful?
    charge = Stripe::Charge.retrive(postcard.stripe_charge_id)
    return charge['paid']
  end

  def lob
    @lob ||= Lob::Client.new(api_key: ENV['LOB_SECRET_API_KEY'])
  end
end
