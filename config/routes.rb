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

  namespace :admin do
    get '/', to: 'dashboard#index', as: 'dashboard'

    resources :curators do
      resources :songs
    end

    resources :subscriptions, only: [:index, :create, :destroy]

    resources :genres

    resources :users

    resource :profile, only: [:show, :edit, :update]

    resource :masquerade, only: [:create, :destroy]
  end

  resource :session, path_names: { new: 'login' }, only: [:new, :create, :destroy]
  get '/session/logout', to: 'sessions#destroy', as: 'logout'

  resources :tokens, only: :show
end
