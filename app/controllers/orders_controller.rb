class OrdersController < ApplicationController
  def index
    @orders = current_user
                 .orders
                 .completed
                 .includes(:recipients)
                 .page(params[:page])
                 .order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end