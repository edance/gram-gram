module ApplicationHelper
  def copyright_year
    DateTime.now.year
  end

  def canonical_url
    url_for(host: 'www.gramgram.app', protocol: 'https', only_path: false)
  end
end
