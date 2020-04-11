class BuilderController < ApplicationController
  attr_reader :postcard

  before_action :authenticate_user!
  before_action :set_postcard, except: :new

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

  def update_caption
    if postcard.update(caption_params)
      redirect_to build_recipient_path
    else
      render 'caption'
    end
  end

  def recipient
    @recipient = current_user.recipients.default || current_user.recipients.new
  end

  def update_recipient
    @recipient = find_or_initialize_recipient
    postcard.recipient = @recipient

    if @recipient.save && postcard.save
      redirect_to build_payment_path
    else
      render 'recipient'
    end
  end

  def update_payment
    current_user.add_default_stripe_source(token) if token

    charge = process_stripe_charge
    if charge && postcard.update(stripe_charge_id: charge[:id])
      redirect_to build_success_path
    else
      render 'payment'
    end
  rescue Stripe::CardError => e
    @card_error = e
    render 'payment'
  end

  private

  def set_postcard
    @postcard = current_user.postcards.find(params[:id])
  end

  def user_params
    params.permit(USER_PARAMS)
  end

  def recipient_params
    params.require(:recipient).permit(RECIPIENT_PARAMS)
  end

  def caption_params
    params.require(:postcard).permit(:caption)
  end

  def process_stripe_charge
    opts = {
      amount: Postcard::PRICE,
      currency: 'usd',
      description: STRIPE_CHARGE_DESCRIPTION,
      customer: current_user.payment_customer_id,
      metadata: stripe_metadata
    }
    Stripe::Charge.create(opts, idempotency_key: postcard.id)
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
    params[:token]
  end

  def find_or_initialize_recipient
    id = params[:recipient_id]
    return current_user.recipients.find(id) if id

    current_user.recipients.new(recipient_params)
  end
end
