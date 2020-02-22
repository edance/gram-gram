class HomeController < ApplicationController
  def index
    return redirect_to photos_path if instagram_connected?

    return redirect_to welcome_path if user_signed_in?

    redirect_to new_user_session_path
  end

  def instagram_connected?
    user_signed_in? && current_user.instagram?
  end
end
