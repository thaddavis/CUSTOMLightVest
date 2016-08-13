Rails.application.routes.draw do

  resources :payment_profiles
  post 'payment_profiles/switch_plan/:id' => 'payment_profiles#switch_plan', as: "switch_plan"
  post 'payment_profiles/add_card/:id' => 'payment_profiles#add_card', as: "add_card"
  post 'payment_profiles/remove_card/:id/:fingerprint' => 'payment_profiles#remove_card', as: "remove_card"
  post 'payment_profiles/set_default_card/:id' => 'payment_profiles#set_default_card', as: "set_default_card"

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

  mount StripeEvent::Engine, at: '/stripe-event' # provide a custom path

  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end
end
