class RecipientsController < ApplicationController
  before_action :authenticate_user!

  RECIPIENT_PARAMS = %i[
    name
    address_line1
    address_line2
    address_city
    address_state
    address_zip
  ].freeze

  def index
    @recipients = current_user.recipients
  end

  def create
    recipient = current_user.recipients.new(recipient_params)

    if recipient.save
      redirect_to recipients_path
    else
      render 'new'
    end
  end

  private

  def recipient_params
    params.require(:recipient).permit(RECIPIENT_PARAMS)
  end
end
