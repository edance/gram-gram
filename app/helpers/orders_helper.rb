module OrdersHelper
  def badge_color(postcard_receipt)
    return 'badge-success' if postcard_receipt.delivered?
    return 'badge-danger' if postcard_receipt.delivery_failed?

    return 'badge-secondary'
  end
end
