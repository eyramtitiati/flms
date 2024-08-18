# config/routes.rb
Rails.application.routes.draw do
  get "home/index"
  devise_for :users

  resources :memberships do
    member do
      get 'flutterwave_payment', to: 'memberships#flutterwave_payment'
      get 'payment_success', to: 'memberships#payment_success'
      get 'payment_cancel', to: 'memberships#payment_cancel'
    end
  end
  # Root path redirects to the user login page
  root to: redirect('/users/sign_in')

  get '/home', to: 'home#index', as: 'home'

  namespace :admin do
    root to: 'dashboard#index'  # Admin dashboard root
    resources :users
  end

  # Ensure the admin login path works as well
  devise_scope :user do
    get 'admin/login', to: 'devise/sessions#new'
  end
end
