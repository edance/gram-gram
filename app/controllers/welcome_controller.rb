class WelcomeController < ApplicationController
  before_action :authenticate_user!

  after_action :save_photos, only: :loading

  def save_photos
    # Wait a few seconds in case the user doesn't have any photos
    SaveInstagramPhotosJob.set(wait: 2.seconds).perform_later(current_user)
  end
end
