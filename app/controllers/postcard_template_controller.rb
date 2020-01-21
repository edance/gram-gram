class PostcardTemplateController < ApplicationController
  layout false

  before_action :set_postcard

  def front
    opt = params[:option]

    render "front#{opt}"
  end

  def back
    opt = params[:option]

    render "back#{opt}"
  end

  private

  def set_postcard
    @postcard = Postcard.order(:created_at).last
  end
end
