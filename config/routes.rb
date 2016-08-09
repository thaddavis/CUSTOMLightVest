Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  resources :users
  root to: "static_pages#home"



end
