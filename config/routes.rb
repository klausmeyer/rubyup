require 'sidekiq/web'

Rails.application.routes.draw do
  root to: redirect('/repositories')

  resources :repositories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :jobs, only: [:index, :show, :new, :create]
  resources :identities, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  mount Sidekiq::Web => '/sidekiq'
end
