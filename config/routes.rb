Rails.application.routes.draw do

  root 'lifehacks#index'
  resources :lifehacks, only: [:index, :new, :create, :destroy]

  resources :lifehacks do
    collection do
      get 'search'
    end
  end

  resources :lifehacks, only: [:show] do
    resources :reviews, only: [:new, :create, :index, :destroy]
  end

  resources :reviews, only: [:show] do
    resources :votes, only: [:create, :update]
  end

  devise_for :users
  resources :users, only: [:index, :show]

  namespace :api do
    namespace :v1 do
      resources :reviews, only: [:show] do
        resources :votes, only: [:create, :update]
      end
    end
  end
end
