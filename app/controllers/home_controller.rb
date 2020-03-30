class HomeController < ApplicationController
  def index
    redirect_to photos_path if current_user.present?
  end
end
