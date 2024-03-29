class BuilderController < ApplicationController
  attr_reader :order

  before_action :authenticate_user!
  before_action :set_order, except: :new

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
    order = Order.create(photo: photo)

    if current_user.recipients.empty?
      return redirect_to build_new_recipient_path(order)
    end

    if current_user.recipients.length == 1
      order.recipients << current_user.recipients.first
    end

    redirect_to build_recipients_path(order)
  end

  def new_recipient
    @recipient = current_user.recipients.new
  end

  def recipients
    @recipients = current_user.recipients.order(:name)
  end

  def create_recipient
    @recipient = current_user.recipients.new(recipient_params)
    order.recipients << @recipient

    if @recipient.save && order.save
      redirect_to build_recipients_path
    else
      render 'recipient'
    end
  end

  def update_recipients
    recipient_ids = params.require(:order)[:recipient_ids]
    recipients = current_user.recipients.where(id: recipient_ids)
    order.recipients = recipients

    if order.save && order.recipients.count > 0
      redirect_to build_caption_path
    else
      @recipients = current_user.recipients.order(:name)
      render 'recipients'
    end
  end

  def update_caption
    if order.update(caption_params)
      redirect_to build_payment_path
    else
      render 'caption'
    end
  end

  def update_payment
    current_user.update(email: email) if email
    current_user.add_default_stripe_source(token) if token

    charge = process_stripe_charge
    if charge && order.update(stripe_charge_id: charge[:id])
      redirect_to build_success_path
    else
      render 'payment'
    end
  rescue Stripe::CardError => e
    @card_error = e
    render 'payment'
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def user_params
    params.permit(USER_PARAMS)
  end

  def recipient_params
    params.require(:recipient).permit(RECIPIENT_PARAMS)
  end

  def caption_params
    params.require(:order).permit(:caption)
  end

  def process_stripe_charge
    opts = {
      amount: order.price_in_cents,
      currency: 'usd',
      description: STRIPE_CHARGE_DESCRIPTION,
      customer: current_user.payment_customer_id,
      metadata: stripe_metadata
    }
    Stripe::Charge.create(opts, idempotency_key: order.id)
  end

  def stripe_metadata
    {
      order_id: order.id
    }
  end

  def token
    params[:token]
  end

  def email
    params[:email]
  end

  def find_or_initialize_recipient
    id = params[:recipient_id]
    return current_user.recipients.find(id) if id

    current_user.recipients.new(recipient_params)
  end
end
