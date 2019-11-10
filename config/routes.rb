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
  get '/photos/:photo_id/new', to: 'builder#new', as: 'build_new'

  get '/sender/:id/caption', to: 'builder#caption', as: 'build_caption'
  get '/sender/:id/address', to: 'builder#recipient', as: 'build_recipient'
  get '/sender/:id/payment', to: 'builder#payment', as: 'build_payment'

  patch '/sender/:id/caption', to: 'builder#update_caption', as: 'update_caption'
  patch '/sender/:id/address', to: 'builder#update_recipient', as: 'update_recipient'
  patch '/sender/:id/payment', to: 'builder#update_payment', as: 'update_payment'

  get '/photos/:photo_id/send', to: 'postcards#new', as: 'postcard_send'
  post '/photos/:photo_id/send', to: 'postcards#create', as: 'postcard_create'
  resources :postcards, only: %i[index show]
end
