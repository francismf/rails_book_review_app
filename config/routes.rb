Rails.application.routes.draw do
 devise_for :users
 resources :books do
 	resources :reviews
 end
 root 'books#index'
 get 'search', to: 'search#search'
end
