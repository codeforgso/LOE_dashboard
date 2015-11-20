Rails.application.routes.draw do
  resources :inspections, only: [:show, :index]

  root 'pages#index'
end
