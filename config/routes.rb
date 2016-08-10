Rails.application.routes.draw do

  devise_for :users, :controllers => {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users
  get 'home'    => 'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
