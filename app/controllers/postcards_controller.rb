class PostcardsController < ApplicationController
  RECIPIENT_PARAMS = %i[
    address_line1
    address_line2
    city
    state
    zip
  ].freeze

  def index
    @postcards = current_user.postcards
  end

  def show
    @postcard = current_user.postcards.find(params[:id])
  end

  def new
    @photo = photo
    @postcard = Postcard.new(photo: photo)
  end

  def create
    recipient = current_user.recipients.create(recipient_params)
    @postcard = Postcard.new(postcard_params)
    @postcard.photo = photo
    @postcard.recipient = recipient

    if @postcard.save
      redirect_to @postcard
    else
      render 'new'
    end
  end

  private

  def photo
    @photo = current_user.photos.find(params[:photo_id])
  end

  def recipient_params
    params.require(:postcard).require(:recipient).permit(:address_line1)
  end

  def postcard_params
    params.require(:postcard).permit(RECIPIENT_PARAMS)
  end
end
