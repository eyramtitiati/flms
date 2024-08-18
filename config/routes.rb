Rails.application.routes.draw do
  # Devise routes for admins
  devise_for :admins

  # Namespace for admin routes
  namespace :admin do
    root to: "dashboard#index"  # Example admin dashboard route
    # Other admin routes can go here
  end

  # Other non-admin routes go here
end
