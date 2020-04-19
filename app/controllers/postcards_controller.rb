class PostcardsController < ApplicationController
  def index
    @orders = current_user
                 .orders
                 .completed
                 .page(params[:page])
                 .order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
