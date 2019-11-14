class BuilderController < ApplicationController
  include StaticHelper

  STRIPE_CHARGE_DESCRIPTION = 'GramGram Photo'.freeze
  RECIPIENT_PARAMS = %i[
    name
    address_line1
    address_line2
    address_city
    address_state
    address_zip
  ].freeze

  def new
    photo = current_user.photos.find(params[:photo_id])
    postcard = Postcard.create(photo: photo)

    redirect_to build_caption_path(postcard)
  end

  def caption
    @postcard = postcard
  end

  def update_caption
    if postcard.update(caption_params)
      redirect_to build_recipient_path
    else
      render 'caption'
    end
  end

  def recipient
    @postcard = postcard
  end

  # TODO: select from dropdown
  def update_recipient
    recipient = current_user.recipients.new(recipient_params)
    postcard.recipient = recipient

    if recipient.save && postcard.save
      redirect_to build_payment_path
    else
      render 'recipient'
    end
  end

  def payment
    @postcard = postcard
  end

  # TODO: add saving of charge
  def update_payment
    create_charge

    redirect_to root_path
  end

  private

  def postcard
    @postcard = current_user.postcards.find(params[:id])
  end

  def recipient_params
    params.require(:postcard).require(:recipient).permit(RECIPIENT_PARAMS)
  end

  def caption_params
    params.require(:postcard).permit(:caption)
  end

  def create_charge
    charge = process_stripe_charge
    postcard.update_attribute(:stripe_charge_id, charge[:id])
    flash[:notice] = 'Your photo has been sent!'
  rescue StandardError
    flash[:notice] = "We're having issues processing your payment. Please "\
      "email us at #{help_email} if the problem persists."
  end

  def process_stripe_charge
    Stripe::Charge.create(
      amount: Postcard::PRICE,
      currency: 'usd',
      description: STRIPE_CHARGE_DESCRIPTION,
      source: token,
      metadata: stripe_metadata
    )
  end

  def stripe_metadata
    {
      postcard_id: postcard.id,
      user_id: current_user.id,
      user_email: current_user.email
    }
  end

  def token
    params.require(:token)
  end
end
