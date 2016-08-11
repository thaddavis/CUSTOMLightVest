Rails.application.routes.draw do

  resources :payment_profiles
  post 'payment_profiles/switch_plan/:id' => 'payment_profiles#switch_plan', as: "switch_plan"

  resources :plans
  devise_for :users, :controllers => {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users
  get '/' => 'static_pages#home', as: 'root'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'



  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end
end
