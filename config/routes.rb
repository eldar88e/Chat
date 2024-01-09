Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  resources :users do
    resources :messages, only: [:create, :index]
  end

  resources :rooms, only: [:create] do
    resources :messages, only: [:create, :index]
  end
end
