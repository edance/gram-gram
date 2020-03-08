class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def loading
    SaveInstagramPhotosJob.perform_later(current_user)
  end
end
