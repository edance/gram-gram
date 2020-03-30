class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_instagram!, only: :index
  before_action :check_sync_at!, only: :index

  def index
    @photos = current_user
              .photos
              .page(params[:page])
              .order(ig_timestamp: :desc)
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end

  private

  def check_instagram!
    redirect_to connect_path unless current_user.instagram?
  end

  def check_sync_at!
    return if current_user.sync_at.nil?

    redirect_to reconnect_path if current_user.sync_at < 1.day.ago
  end
end
