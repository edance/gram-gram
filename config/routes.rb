Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Home route: redirects to login or photos
  root to: 'home#index'

  # Authentication routes
  get '/auth/:provider', to: 'authentication#authorize', as: 'authentication'
  get '/auth/:provider/callback', to: 'authentication#callback'

  get '/connect', to: 'welcome#connect'
  get '/reconnect', to: 'welcome#reconnect'
  get '/loading', to: 'welcome#loading'

  resources :photos, only: %i[index show]
  get '/photos/:photo_id/new', to: 'builder#new', as: 'build_new'

  get '/sender/:id/caption', to: 'builder#caption', as: 'build_caption'
  get '/sender/:id/address', to: 'builder#recipient', as: 'build_recipient'
  get '/sender/:id/payment', to: 'builder#payment', as: 'build_payment'
  get '/sender/:id/success', to: 'builder#success', as: 'build_success'

  patch '/sender/:id/caption', to: 'builder#update_caption', as: 'update_caption'
  patch '/sender/:id/address', to: 'builder#update_recipient', as: 'update_recipient'
  patch '/sender/:id/payment', to: 'builder#update_payment', as: 'update_payment'

  get '/photos/:photo_id/send', to: 'postcards#new', as: 'postcard_send'
  post '/photos/:photo_id/send', to: 'postcards#create', as: 'postcard_create'
  resources :postcards, only: :index

  resources :recipients

  get '/template/back', to: 'postcard_template#back'
  get '/template/front', to: 'postcard_template#front'

  mount ActionCable.server => '/cable'
end
