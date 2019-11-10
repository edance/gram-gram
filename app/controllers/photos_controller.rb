class PhotosController < ApplicationController
  def index
    @photos = current_user.photos
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end
end
