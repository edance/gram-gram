class OrderMailer < ApplicationMailer
  attr_accessor :order

  def receipt
    @order = params[:order]
    @user = order.user
    subject = "We're processing your GramGram order #{order.public_id}"

    mail(to: @user.email, subject: subject)
  end
end
