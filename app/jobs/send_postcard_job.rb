class SendPostcardJob < ApplicationJob
  queue_as :default

  attr_accessor :postcard

  def perform(postcard)
    @postcard = postcard
    return if postcard.nil? || !postcard.pending?

    return unless stripe_charge_successful?

    lob_card = lob.postcards.create(
      description: postcard.lob_description,
      to: postcard.recipient.address,
      front: front_html,
      back: back_html
    )

    postcard.update(lob_id: lob_card['id'], status: :processing)
  end

  def locals
    {
      :@postcard => postcard
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

  def stripe_charge_successful?
    charge = Stripe::Charge.retrieve(postcard.stripe_charge_id)
    charge['paid']
  end

  def lob
    @lob ||= Lob::Client.new(api_key: ENV['LOB_SECRET_API_KEY'])
  end
end
