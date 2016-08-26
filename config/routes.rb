Rails.application.routes.draw do
  resources :cases, only: [:show, :index] do
    get 'autocomplete', on: :collection
  end
  resources :case_histories, only: [:show, :index]
  resources :inspections, only: [:show, :index]
  resources :violations, only: [:show, :index]
  resources :pages, only: [:index]

  root 'cases#index'
end
