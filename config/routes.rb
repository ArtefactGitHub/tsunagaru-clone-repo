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

    namespace :friend do
      root to: 'top#show'
      resources :friends, only: %i[index destroy]
      resources :requests, only: %i[index create destroy]
    end

    namespace :setting do
      root to: 'top#show'
      resource :message_button_list, only: %i[show update]
    end
  end

  resources :rooms, only: %i[show]

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
