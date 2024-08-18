class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_venue, only: [:index, :new, :create]
  
    layout 'admin', if: -> { current_user.admin? }
  
    def index
        if @venue
          @bookings = @venue.bookings.order(:booking_date)
        else
          @bookings = Booking.includes(:venue, :user).order(:booking_date) if current_user.admin?
        end
    end
      
  
    def new
      @booking = @venue.bookings.build
    end
  
    def create
      @booking = @venue.bookings.build(booking_params)
      @booking.user = current_user
      if @booking.save
        redirect_to venue_bookings_path(@venue), notice: 'Booking was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    def set_venue
      @venue = Venue.find(params[:venue_id]) if params[:venue_id]
    end
  
    def booking_params
      params.require(:booking).permit(:booking_date, :venue_id)
    end
  end
  