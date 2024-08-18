class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_venue, except: [:index, :new, :create]
    before_action :set_booking, only: [:edit, :update, :destroy]
    before_action :set_venues, only: [:new, :edit]
  
    layout 'admin', if: -> { current_user.admin? }
  
    def index
      @bookings = if @venue
                    @venue.bookings.order(:booking_date)
                  else
                    Booking.includes(:venue, :user).order(:booking_date)
                  end
    end
  
    def new
      @booking = Booking.new
    end
  
    def create
      @booking = Booking.new(booking_params)
      if @booking.save
        redirect_to all_bookings_path, notice: 'Booking was successfully created.'
      else
        set_venues
        render :new
      end
    end
  
    def edit; end
  
    def update
      if @booking.update(booking_params)
        redirect_to all_bookings_path, notice: 'Booking was successfully updated.'
      else
        set_venues
        render :edit
      end
    end
  
    def destroy
      @booking.destroy
      redirect_to all_bookings_path, notice: 'Booking was successfully deleted.'
    end
  
    private
  
    def set_venues
        @venues = Venue.all
    end
  
    def set_booking
      @booking = Booking.find(params[:id])
    end
  
    def set_venues
      @venues = Venue.all
    end
  
    def booking_params
      params.require(:booking).permit(:booking_date, :user_id, :venue_id)
    end
  end
  