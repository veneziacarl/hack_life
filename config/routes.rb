Rails.application.routes.draw do

  root 'lifehacks#index'
  resources :lifehacks, only: [:index, :new, :create]

  resources :lifehacks, only: [:show] do
    resources :reviews, only: [:new, :create, :index]
  end

  resources :reviews, only: [:show] do
    resources :votes, only: [:create, :update]
  end

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :reviews, only: [:show] do
        resources :votes, only: [:create, :update]
      end
    end
  end
end
