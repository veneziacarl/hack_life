Rails.application.routes.draw do
  devise_for :users

  root 'lifehacks#index'
  resources :lifehacks, only: [:index, :new, :create, :destroy]

  resources :lifehacks do
    collection do
      get 'search'
    end
  end

  resources :lifehacks, only: [:show] do
    resources :reviews, only: [:new, :create, :index, :destroy, :edit, :update]
  end

  resources :reviews, only: [:show] do
    resources :votes, only: [:create, :update]
  end
  resources :users, only: [:index, :show]

  namespace :api do
    namespace :v1 do
      resources :reviews, only: [:show] do
        resources :votes, only: [:create, :update]
      end
    end
  end
end
