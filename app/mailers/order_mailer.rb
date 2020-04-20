class OrderMailer < ApplicationMailer
  attr_accessor :order

  def receipt
    @order = params[:order]
    @user = order.user

    mail(to: @user.email, subject: 'We\'re processing your GramGram order')
  end
end
