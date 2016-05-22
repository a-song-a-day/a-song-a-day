Rails.application.routes.draw do
  root to: 'home#index'

  namespace :signup do
    get '/start', to: 'start#new'
    post '/start', to: 'start#create'

    get '/genres', to: 'genres#new'
    get '/genres', to: 'genres#create'

    get '/curators', to: 'curators#new'
    get '/curators', to: 'curators#create'

    get '/welcome', to: 'welcome#index'
  end

  resources :sessions, path_names: { new: 'login' }, only: [:new, :create, :destroy]
  get '/sessions/logout', to: 'sessions#destroy'
end
