class SendPostcardJob < ApplicationJob
  queue_as :default

  attr_accessor :postcard

  def perform(postcard_id)
    @postcard = Postcard.find_by_id(postcard_id)
    return if postcard.nil?

    lob.postcards.create(
      description: postcard.lob_description,
      to: postcard.recipient.address,
      front: ENV['POSTCARD_FRONT_TEMPLATE_ID'],
      back: ENV['POSTCARD_BACK_TEMPLATE_ID'],
      merge_variables: merge_variables
    )
  end

  def merge_variables
    {
      photo_url: postcard.photo.ig_permalink,
      caption: postcard.caption
    }
  end

  def lob
    @lob ||= Lob::Client.new(api_key: ENV['LOB_SECRET_API_KEY'])
  end
end
