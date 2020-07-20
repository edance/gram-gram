class Api::PhotosController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  respond_to :json

  def create
    respond_with current_user.photos.create(photo_params)
  end

  private

  def photo_params
    params.require(:photo).permit(:url)
  end
end
