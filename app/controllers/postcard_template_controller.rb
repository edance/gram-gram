class PostcardTemplateController < ApplicationController
  layout false

  before_action :set_order

  def front
    opt = params[:option]

    render "front#{opt}"
  end

  def back
    opt = params[:option]

    render "back#{opt}"
  end

  private

  def set_order
    @order = Order.order(:created_at).last
  end
end
