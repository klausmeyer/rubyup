require 'sidekiq/web'

Rails.application.routes.draw do
  root to: redirect('/repositories')

  devise_for :users

  resources :repositories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :jobs, only: [:index, :show, :new, :create] do
    put :retry, on: :member
  end
  resources :versions, only: [:index, :new, :create]
  resources :identities, only: [:index, :show, :new, :create, :destroy]

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
