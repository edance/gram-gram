module OrdersHelper
  def badge_color(postcard_receipt)
    return 'badge-success' if postcard_receipt.processed_for_delivery?
    return 'badge-danger' if postcard_receipt.returned_to_sender?

    'badge-secondary'
  end

  def formatted_delivery_date(postcard_receipt)
    postcard_receipt.expected_delivery_date.strftime('%b %-d, %Y')
  end
end
