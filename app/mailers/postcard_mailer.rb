class PostcardMailer < ApplicationMailer
  attr_accessor :postcard

  def receipt
    @postcard = params[:postcard]
    @user = postcard.user

    mail(to: @user.email, subject: 'Your photo has been sent!')
  end

  def out_for_delivery
    @postcard = params[:postcard]
    @user = postcard.user

    mail(to: @user.email, subject: 'Your photo is out for delivery!')
  end
end
