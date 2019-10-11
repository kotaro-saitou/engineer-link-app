Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'contact', to: 'toppages#contact'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :new, :create, :edit, :update] do
    member do
      get :add_tag
      get :followings
      get :followers
    end
  end
  
  resources :posts, only: [:index, :show, :create, :destroy]
  resources :tags, only: [:index, :show, :create, :destroy]
  resources :tag_relations, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :messages, only: [:index, :show]
  
  mount ActionCable.server => '/cable'
  
end
