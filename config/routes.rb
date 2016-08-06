require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

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

  resources :curators, only: [:show]

  namespace :admin do
    get '/', to: 'dashboard#index', as: 'dashboard'

    resources :curators do
      resources :songs
    end

    resources :subscriptions, only: [:index, :create, :destroy]

    resources :genres

    resources :users do
      resources :subscriptions, only: [:index, :create, :destroy]
    end

    resource :profile, only: [:show, :edit, :update]

    resource :masquerade, only: [:create, :destroy]

    post '/random/:song_id', to: 'random#copy', as: 'random_copy'
  end

  resource :session, path_names: { new: 'login' }, only: [:new, :create, :destroy]
  get '/session/logout', to: 'sessions#destroy', as: 'logout'

  resources :tokens, only: :show
end
