class OrdersController < ApplicationController
  def index
    @orders = current_user
                 .orders
                 .completed
                 .includes(:postcard_receipts)
                 .page(params[:page])
                 .order(created_at: :desc)
  end

  def show
    @order = current_user
               .orders
               .includes(:postcard_receipts)
               .find(params[:id])
  end
end
