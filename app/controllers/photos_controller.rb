class PhotosController < ApplicationController
  before_action :redirect_guests

  def index
    @photos = current_user.photos
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end
end
