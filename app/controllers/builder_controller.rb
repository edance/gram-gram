class BuilderController < ApplicationController
  before_action :authenticate_user!

  STRIPE_CHARGE_DESCRIPTION = 'GramGram Photo'.freeze
  USER_PARAMS = %i[name email].freeze
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
    @recipient = current_user.recipients.order(:created_at).last
  end

  # TODO: select from dropdown
  def update_recipient
    recipient = current_user.recipients.new(recipient_params)

    if recipient.save && postcard.update(recipient: recipient)
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
    current_user.add_default_stripe_source(token)

    charge = process_stripe_charge
    if charge && postcard.update(stripe_charge_id: charge[:id])
      redirect_to build_success_path
    else
      render 'payment'
    end
  end

  def success
    @postcard = postcard
  end

  private

  def postcard
    @postcard = current_user.postcards.find(params[:id])
  end

  def user_params
    params.permit(USER_PARAMS)
  end

  def recipient_params
    params.require(:postcard).require(:recipient).permit(RECIPIENT_PARAMS)
  end

  def caption_params
    params.require(:postcard).permit(:caption)
  end

  def process_stripe_charge
    Stripe::Charge.create(
      amount: Postcard::PRICE,
      currency: 'usd',
      description: STRIPE_CHARGE_DESCRIPTION,
      customer: current_user.payment_customer_id,
      metadata: stripe_metadata
    )
  end

  def stripe_metadata
    {
      postcard_id: postcard.id
    }
  end

  def create_stripe_customer
    return current_user.payment_customer_id if current_user.payment_customer_id

    customer = Stripe::Customer.create(
      email: current_user.email,
      name: current_user.ig_username,
      source: token
    )
    customer.id
  end

  def token
    params.require(:token)
  end
end
