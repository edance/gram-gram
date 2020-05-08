Rails.application.config.session_store(
  :cookie_store,
  expire_after: 14.days,
  secure: Rails.env.production?, # flags cookies as secure only in production
  same_site: :strict,
  httponly: true # should be true by default for all cookies
)
