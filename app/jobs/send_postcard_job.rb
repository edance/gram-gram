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
      front: front_html,
      back: back_html
    )
  end

  def locals
    {
      photo_url: postcard.photo.ig_permalink,
      caption: postcard.caption
    }
  end

  def front_html
    controller.render_to_string('postcard_template/front', locals: locals)
  end

  def back_html
    controller.render_to_string('postcard_template/back', locals: locals)
  end

  def controller
    @controller ||= ApplicationController.new
  end

  def stripe_charge_successful?
    charge = Stripe::Charge.retrive(postcard.stripe_charge_id)
    charge['paid']
  end

  def lob
    @lob ||= Lob::Client.new(api_key: ENV['LOB_SECRET_API_KEY'])
  end
end
