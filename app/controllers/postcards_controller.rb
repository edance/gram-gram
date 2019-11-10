class PostcardsController < ApplicationController
  def index
    @postcards = current_user.postcards
  end

  def show
    @postcards = current_user.postcards.find(params[:id])
  end

  def new
    @postcard = Postcard.new
  end

  def create
    @postcard = Postcard.new(create_params)
    if @payment_record.save
      redirect_to @postcard
    else
      render 'new'
    end
  end

  private

  def create_params
    params.require(:postcard).permit(:name)
  end
end
