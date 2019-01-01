Rails.application.routes.draw do
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :user_sessions, only: %i[new create destroy]

  root to: 'rooms#show'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
