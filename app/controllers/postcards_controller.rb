class PostcardsController < ApplicationController
  def index
    @postcards = current_user
                 .postcards
                 .where.not(status: :pending)
                 .page(params[:page])
                 .order(created_at: :desc)
  end
end
