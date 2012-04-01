Songtape::Application.routes.draw do

  resources :tracks

  resources :users

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/logout', to: 'sessions#destroy'

  root :to => "home#index"
end
