class RecipientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: %i[show edit update destroy]

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

  def new
    @recipient = Recipient.new
  end

  def create
    recipient = current_user.recipients.new(recipient_params)

    if recipient.save
      redirect_to recipients_path
    else
      render 'new'
    end
  end

  def update
    if @recipient.update(recipient_params)
      redirect_to recipients_path
    else
      render 'edit'
    end
  end

  def destroy
    @recipient.destroy
  end

  private

  def recipient_params
    params.require(:recipient).permit(RECIPIENT_PARAMS)
  end

  def set_recipient
    @recipient = current_user.recipients.find(params[:id])
  end
end
