Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Home route: redirects to login or photos
  root to: 'home#index'

  # Instagram Auth Routes
  get '/auth/instagram', to: 'instagram_auth#authorize', as: 'instagram_auth'
  get '/auth/instagram/callback', to: 'instagram_auth#callback'

  # Google One-tap Auth Route
  post '/auth/google/callback', to: 'google_auth#callback'

  get '/connect', to: 'welcome#connect'
  get '/reconnect', to: 'welcome#reconnect'
  get '/loading', to: 'welcome#loading'

  resources :photos, only: %i[index show]
  get '/photos/:photo_id/new', to: 'builder#new', as: 'build_new'

  get '/sender/:id/preview', to: 'builder#preview', as: 'build_preview'
  get '/sender/:id/caption', to: 'builder#caption', as: 'build_caption'
  get '/sender/:id/recipients', to: 'builder#recipients', as: 'build_recipients'
  get '/sender/:id/address', to: 'builder#recipient', as: 'build_new_recipient'
  get '/sender/:id/payment', to: 'builder#payment', as: 'build_payment'
  get '/sender/:id/success', to: 'builder#success', as: 'build_success'

  patch '/sender/:id/caption', to: 'builder#update_caption', as: 'update_caption'
  patch '/sender/:id/address', to: 'builder#create_recipient', as: 'create_recipient'
  patch '/sender/:id/recipients', to: 'builder#update_recipients', as: 'update_recipients'
  patch '/sender/:id/payment', to: 'builder#update_payment', as: 'update_payment'

  get '/postcards', to: 'orders#index', as: :orders
  get '/postcards/:id', to: 'orders#show', as: :order

  resources :recipients, except: %i[show]

  namespace :api do
    resources :photos, only: %i[create]
  end

  mount ActionCable.server => '/cable'

  # Static routes
  get '/privacy' => 'static#privacy'
  get '/terms' => 'static#terms'

  # Webhooks
  post '/lob' => 'lob_webhook#webhook'

  # Development only routes
  if Rails.env.development?
    get '/template/back', to: 'postcard_template#back'
    get '/template/front', to: 'postcard_template#front'
  end

  get '/:slug' => 'posts#show'
end
