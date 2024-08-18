# app/controllers/admin/users_controller.rb
class Admin::UsersController < Admin::BaseController
  layout 'admin'  # Ensure it uses the admin layout

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      update_user_roles(@user)  # Assign roles
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      update_user_roles(@user)  # Update roles
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, role_ids: [])
  end

  def update_user_roles(user)
    user.roles.clear
    role_ids = params[:user][:role_ids]
    role_ids.each do |role_id|
      next if role_id.blank?
      role = Role.find(role_id)
      user.add_role(role.name)
    end
  end
end
