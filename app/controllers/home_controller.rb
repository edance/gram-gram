class HomeController < ApplicationController
  before_action :redirect_users
  after_action -> { request.session_options[:skip] = true }

  def index
    expires_in 3.hours,
               public: true,
               stale_while_revalidate: 60.seconds,
               stale_if_error: 5.minutes

    @posts = ArticleService.new.all_articles
  end

  private

  def redirect_users
    redirect_to photos_path if current_user.present?
  end
end
