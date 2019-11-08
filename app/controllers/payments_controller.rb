class PaymentsController < ApplicationController
  STRIPE_CHARGE_DESCRIPTION = 'GramGram Photo'.freeze

  before_action :validate_token

  def charge
    create_charge
    flash[:notice] = 'You have been charged!'

    redirect_to root_path
  end

  private

  def token
    params.require(:token)
  end

  def validate_token
    return if token.present?

    head :bad_request
  end

  def create_charge
    Stripe::Charge.create(
      amount: Postcard::PRICE,
      currency: 'usd',
      description: STRIPE_CHARGE_DESCRIPTION,
      source: token
    )
  end
end
