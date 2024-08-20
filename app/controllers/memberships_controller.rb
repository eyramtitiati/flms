# app/controllers/memberships_controller.rb
class MembershipsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_membership, only: [:show, :edit, :update, :destroy, :flutterwave_payment, :payment_success, :payment_cancel]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    # Apply the layout based on the user role
    layout :determine_layout
  
    def index
      @memberships = current_user.admin? ? Membership.all : current_user.memberships
    end
  
    def show
    end
  
    def new
      @membership = current_user.memberships.build
    end
  
    def create
      @membership = current_user.memberships.build(membership_params)
      @membership.status = current_user.admin? ? 'Confirmed' : 'Pending'
  
      if @membership.save
        if current_user.admin?
          redirect_to @membership, notice: 'Membership was successfully created and confirmed.'
        else
          result = FlutterwavePaymentService.new(@membership).initiate_payment
          if result[:success]
            redirect_to result[:payment_link], allow_other_host: true
          else
            flash[:error] = "Payment initialization failed: #{result[:error]}"
            redirect_to @membership
          end
        end
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @membership.update(membership_params)
        if @membership.status == 'Pending' && !current_user.admin?
          result = FlutterwavePaymentService.new(@membership).initiate_payment
          if result[:success]
            redirect_to result[:payment_link], allow_other_host: true
          else
            flash[:error] = "Payment initialization failed: #{result[:error]}"
            redirect_to @membership
          end
        else
          redirect_to @membership, notice: 'Membership was successfully updated.'
        end
      else
        render :edit
      end
    rescue ActiveSupport::MessageVerifier::InvalidSignature => e
      flash[:error] = "There was an error with the request: #{e.message}"
      redirect_to memberships_path
    end
  
    def destroy
      @membership.destroy
      redirect_to memberships_url, notice: 'Membership was successfully deleted.'
    end
  
    def payment_success
      transaction_id = params[:transaction_id]
  
      response = HTTParty.get(
        "https://api.flutterwave.com/v3/transactions/#{transaction_id}/verify",
        headers: {
          "Authorization" => "Bearer FLWSECK_TEST-5888bc2d2331e6137f56fb83be4484f7-X"
        }
      )
  
      if response['status'] == 'success'
        @membership.update(status: 'Confirmed')
        redirect_to @membership, notice: 'Payment was successful. Membership confirmed.'
      else
        flash[:error] = "Payment verification failed. Please contact support."
        redirect_to @membership
      end
    end
  
    def payment_cancel
      redirect_to @membership, alert: 'Payment was cancelled. Your membership is still pending.'
    end
  
    private
  
    def set_membership
      @membership = Membership.find(params[:id])
    end
  
    def membership_params
      permitted_params = [
        :first_name, :last_name, :phone, :email,
        :partner_first_name, :partner_last_name, :partner_phone, :partner_email,
        :male_birth_date, :female_birth_date,
        :male_place_of_birth, :female_place_of_birth,
        :male_residential_address, :female_residential_address,
        :male_born_again, :female_born_again,
        :male_born_again_date, :female_born_again_date,
        :male_born_again_reason, :female_born_again_reason,
        :male_passport_picture, :female_passport_picture, :pastor_name,
        :partner_pastor_name, :ministry, :partner_ministry, :lab_results
      ]
  
      permitted_params << :status if current_user.admin?
  
      params.require(:membership).permit(permitted_params)
    end
  
    def authorize_user!
      unless current_user.admin? || @membership.user == current_user
        redirect_to memberships_path, alert: 'You are not authorized to perform this action.'
      end
    end
  
    # Determines which layout to use based on the user's role
    def determine_layout
      current_user.admin? ? 'admin' : 'application'
    end
end
  