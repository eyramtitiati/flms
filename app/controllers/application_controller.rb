class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def after_sign_in_path_for(resource)
    # Redirect users based on their role
    if resource.admin?
      admin_root_path # Redirect admins to the admin dashboard
    else
      home_path # Redirect regular users to their dashboard or another page
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path  # Redirect to the admin login page
    else
      root_path  # Fallback to the root path for other users
    end
  end
end
