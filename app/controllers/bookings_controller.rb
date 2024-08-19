class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_venue, only: [:new, :create, :index]
    before_action :set_booking, only: [:edit, :update, :destroy]
  
    layout 'admin', if: -> { current_user.admin? }
  
    def index
      @bookings = if @venue
                    @venue.bookings.order(:booking_date)
                  else
                    Booking.includes(:venue, :user).order(:booking_date) if current_user.admin?
                  end
    end
  
    def new
      @booking = Booking.new
    end
  
    def create
      @booking = Booking.new(booking_params)
      @booking.venue = @venue
      @booking.user = current_user
  
      if @booking.save
        # Initiate the payment via Flutterwave
        result = FlutterwavePaymentService.new(@booking).initiate_payment
        if result[:success]
          redirect_to result[:payment_link], allow_other_host: true
        else
          flash[:error] = "Payment initialization failed: #{result[:error]}"
          redirect_to @venue
        end
      else
        render :new
      end
    end
  
    def edit; end
  
    def update
      if @booking.update(booking_params)
        redirect_to all_bookings_path, notice: 'Booking was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @booking.destroy
      redirect_to all_bookings_path, notice: 'Booking was successfully deleted.'
    end

    def payment_success
        transaction_id = params[:transaction_id]
    
        response = HTTParty.get(
          "https://api.flutterwave.com/v3/transactions/#{transaction_id}/verify",
          headers: {
            "Authorization" => "Bearer #{@api_key}"
          }
        )
    
        if response['status'] == 'success'
          @booking.update(status: 'Confirmed')
          redirect_to @booking, notice: 'Payment was successful. Booking confirmed.'
        else
          flash[:error] = "Payment verification failed. Please contact support."
          redirect_to @booking
        end
    end
  
    private
  
    def set_venue
      @venue = Venue.find_by(id: params[:venue_id])
    end
  
    def set_booking
      @booking = Booking.find(params[:id])
    end
  
    def booking_params
      params.require(:booking).permit(:booking_date, :user_id, :venue_id)
    end
end
  