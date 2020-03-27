# Preview all emails at http://localhost:3000/rails/mailers/postcard
class PostcardPreview < ActionMailer::Preview
  def receipt
    PostcardMailer.with(postcard: postcard).receipt
  end

  def out_for_delivery
    PostcardMailer.with(postcard: postcard).out_for_delivery
  end

  private

  def postcard
    @postcard ||= Postcard.order(:created_at).last
  end
end
