# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
    before_action :authenticate_user!  # Use User model for authentication
    before_action :authorize_admin!    # Ensure the user is an admin
  
    private
  
    def authorize_admin!
      # Redirect non-admin users to the homepage with an alert message
      redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin?
    end
  end
  