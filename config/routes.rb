Rails.application.routes.draw do
  get "home/index"
  devise_for :users

  # Routes for memberships with custom payment actions
  resources :memberships do
    member do
      get 'flutterwave_payment', to: 'memberships#flutterwave_payment'
      get 'payment_success', to: 'memberships#payment_success'
      get 'payment_cancel', to: 'memberships#payment_cancel'
    end
  end

  # Routes for venues and nested bookings
  resources :venues do
    resources :bookings do
      member do
        get 'payment_success', to: 'bookings#payment_success'
      end
    end
  end

  # Route for fetching available dates for a location
  resources :locations do
    member do
      get 'available_dates', to: 'locations#available_dates'
    end
  end

  # Global bookings route (admin view all bookings)
  get 'bookings', to: 'bookings#index', as: 'all_bookings'

  # Routes for locations with admin destroy action
  resources :locations, except: [:destroy]
  resources :bookings, only: [:new, :create]

  # Root path redirects to the user login page
  root to: redirect('/users/sign_in')

  # Home page route
  get '/home', to: 'home#index', as: 'home'

  # Admin namespace for users, locations, and venues
  namespace :admin do
    root to: 'dashboard#index'  # Admin dashboard root
    resources :users
    resources :locations, only: [:destroy]
    resources :venues, only: [:destroy]
    
    # Singleton resource for payment settings
    resources :payment_settings, only: [:index, :edit, :update]
  end

  # Ensure the admin login path works as well
  devise_scope :user do
    get 'admin/login', to: 'devise/sessions#new'
  end
end
