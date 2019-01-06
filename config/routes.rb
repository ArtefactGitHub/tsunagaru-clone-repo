Rails.application.routes.draw do
  root to: 'user_sessions#new'

  if Rails.env.development?
    get '/login_as/:user_id', to: 'development/sessions#login_as'
  end

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :user_sessions, only: %i[new create destroy]
  resources :users, only: %i[new create]

  namespace :mypage do
    root to: 'dashboard#show'
  end

  resources :rooms, only: %i[show]

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
