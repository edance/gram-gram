class SendPostcardJob < ApplicationJob
  queue_as :default

  FRONT_TEMPLATE_ID = 'tmpl_e54af2cab69b793'.freeze
  BACK_TEMPLATE_ID = 'tmpl_ef2f5ce8783d9d7'.freeze

  def perform(postcard_id)
    @postcard = Postcard.find_by_id(postcard_id)
    return if @postcard.nil?

    lob.postcards.create(
      description: @postcard.lob_description,
      to: @postcard.recipient.address,
      front: FRONT_TEMPLATE_ID,
      back: BACK_TEMPLATE_ID,
      merge_variables: merge_variables
    )
  end

  def merge_variables
    {
      photo_url: @postcard.photo.ig_permalink,
      caption: @postcard.caption
    }
  end

  def lob
    @lob ||= Lob::Client.new(api_key: ENV['LOB_SECRET_API_KEY'])
  end
end
