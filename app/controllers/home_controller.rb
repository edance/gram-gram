class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_instagram!
  before_action :check_sync_at!

  def index
    redirect_to photos_path
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
