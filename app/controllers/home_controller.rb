class HomeController < ApplicationController
  def index
    return redirect_to photos_path if user_signed_in?

    redirect_to new_user_session_path
  end
end
