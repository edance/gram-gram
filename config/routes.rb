Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Static routes
  root to: 'static#home'
  get '/privacy', to: 'static#privacy'
  get '/terms', to: 'static#terms'

  # Authentication routes
  get 'login', to: redirect('/auth/instagram'), as: 'login'
  get '/auth/:provider', to: 'authentication#authorize'
  get '/auth/:provider/callback', to: 'authentication#callback'
  delete 'logout', to: 'authentication#logout'

  # Payment routes
  get '/payment' => 'static#payment'
  post '/charge' => 'payments#charge'

  resources :photos, only: %i[index show]
end
